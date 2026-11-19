import express from 'express'
import cors from 'cors'
import dotenv from 'dotenv'
import bcrypt from 'bcryptjs'
import jwt from 'jsonwebtoken'
import multer from 'multer'
import nodemailer from 'nodemailer'
import fs from 'node:fs'
import path from 'node:path'
import { fileURLToPath } from 'node:url'
import crypto from 'node:crypto'
import Database from 'better-sqlite3'
dotenv.config()
const __dirname=path.dirname(fileURLToPath(import.meta.url))
const app=express(),PORT=process.env.PORT||4000
const dataDir=path.join(__dirname,'data'),uploadDir=path.join(__dirname,'uploads')
fs.mkdirSync(dataDir,{recursive:true});fs.mkdirSync(uploadDir,{recursive:true})
const dbFile=path.join(dataDir,'store.json')
const sqliteFile=path.join(dataDir,'app.db')
const db=new Database(sqliteFile)
db.exec(`
  PRAGMA foreign_keys=ON;
  CREATE TABLE IF NOT EXISTS users (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    role TEXT NOT NULL DEFAULT 'user',
    reset_token_hash TEXT,
    reset_expires INTEGER,
    created_at TEXT NOT NULL
  );
  CREATE TABLE IF NOT EXISTS login_records (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    logged_in_at TEXT NOT NULL,
    logged_out_at TEXT,
    active INTEGER NOT NULL DEFAULT 1,
    last_seen_at TEXT NOT NULL,
    FOREIGN KEY(user_id) REFERENCES users(id)
  );
  CREATE TABLE IF NOT EXISTS orders (
    id TEXT PRIMARY KEY,
    number INTEGER NOT NULL UNIQUE,
    user_id TEXT,
    customer_name TEXT NOT NULL,
    customer_email TEXT NOT NULL,
    customer_phone TEXT,
    message TEXT,
    items TEXT NOT NULL,
    total INTEGER NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    FOREIGN KEY(user_id) REFERENCES users(id)
  );
`)
try{db.prepare('ALTER TABLE users ADD COLUMN reset_token_hash TEXT').run()}catch{}
try{db.prepare('ALTER TABLE users ADD COLUMN reset_expires INTEGER').run()}catch{}
const nextOrderNumber=()=>{const row=db.prepare('SELECT COALESCE(MAX(number),1041) AS n FROM orders').get();return row.n+1}
const seed={artworks:[
{id:'a1',title:'The Quiet Bloom',category:'Floral',price:2400,description:'A delicate study of balance, patience and the beauty of small beginnings.',size:'A4 · Original artwork',image:'/mandala-hero.jpeg',featured:true},
{id:'a2',title:'Celestial Rhythm',category:'Geometric',price:3200,description:'Repeating forms inspired by the quiet rhythm of the cosmos.',size:'12 × 12 in · Original artwork',image:'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=900&q=85',featured:true},
{id:'a3',title:'A Moment of Stillness',category:'Traditional',price:1800,description:'A meditative composition made one careful dot at a time.',size:'A5 · Original artwork',image:'https://images.unsplash.com/photo-1577083552431-6e5fd01aa342?w=900&q=85'},
{id:'a4',title:'Sun Within',category:'Floral',price:2800,description:'Warm, intricate petals radiating outward from a central point.',size:'10 × 10 in · Original artwork',image:'https://images.unsplash.com/photo-1578301978693-85fa9c0320b9?w=900&q=85'},
{id:'a5',title:'Infinite Lines',category:'Geometric',price:3600,description:'A precise interplay of line, symmetry and negative space.',size:'12 × 16 in · Original artwork',image:'https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?w=900&q=85'},
{id:'a6',title:'Earth & Echo',category:'Contemporary',price:2100,description:'Organic shapes and earthy tones in a contemporary mandala study.',size:'A4 · Original artwork',image:'https://images.unsplash.com/photo-1577083552431-6e5fd01aa342?w=900&q=85'}],
categories:['Floral','Geometric','Traditional','Contemporary'].map((name,i)=>({id:`c${i+1}`,name})),
content:{eyebrow:'ART THAT INVITES YOU TO PAUSE',title:'A little stillness,\\na lot of soul.',intro:'Hand-drawn mandalas and mindful details, created slowly and made to stay with you.'},enquiries:[],admin:null}
let store
if(fs.existsSync(dbFile)){try{store=JSON.parse(fs.readFileSync(dbFile,'utf8'))}catch{store=seed}}else store=seed
if(!store.admin){store.admin={username:process.env.ADMIN_USERNAME||'admin',passwordHash:bcrypt.hashSync(process.env.ADMIN_INITIAL_PASSWORD||'Mandala@123',10),mustChange:true};}
const save=()=>fs.writeFileSync(dbFile,JSON.stringify(store,null,2))
save()
app.use(cors());app.use(express.json({limit:'2mb'}));app.use('/uploads',express.static(uploadDir,{maxAge:'7d',immutable:true}))
const storage=multer.diskStorage({destination:uploadDir,filename:(req,file,cb)=>cb(null,`${Date.now()}-${crypto.randomBytes(5).toString('hex')}${path.extname(file.originalname).toLowerCase()}`)})
const upload=multer({storage,limits:{fileSize:8*1024*1024},fileFilter:(req,file,cb)=>cb(null,/^image\/(jpeg|png|webp|gif)$/.test(file.mimetype))})
const auth=(req,res,next)=>{try{const token=(req.headers.authorization||'').replace(/^Bearer\s+/,'');req.admin=jwt.verify(token,process.env.JWT_SECRET||'dev-only-change-this-secret');if(req.admin.role!=='admin')return res.status(403).json({error:'Admin access required.'});next()}catch{return res.status(401).json({error:'Please sign in again.'})}}
const userAuth=(req,res,next)=>{
  try{
    const token=(req.headers.authorization||'').replace(/^Bearer\s+/,'')
    req.user=jwt.verify(token,process.env.JWT_SECRET||'dev-only-change-this-secret')
    if(!req.user.userId)return res.status(401).json({error:'Please sign in again.'})
    next()
  }catch{return res.status(401).json({error:'Please sign in again.'})}
}
const adminAuth=(req,res,next)=>{
  try{
    const token=(req.headers.authorization||'').replace(/^Bearer\s+/,'')
    req.admin=jwt.verify(token,process.env.JWT_SECRET||'dev-only-change-this-secret')
    if(req.admin.role!=='admin')return res.status(403).json({error:'Admin access required.'})
    next()
  }catch{return res.status(401).json({error:'Please sign in again.'})}
}
async function notify(subject,html){const to=process.env.NOTIFY_EMAIL;if(!to){console.log(`\n[NEW ENQUIRY] ${subject}\n${html}\n`);return}if(!process.env.SMTP_HOST){console.log('[EMAIL NOT SENT] Configure SMTP_HOST and SMTP credentials in server/.env');return}try{const transport=nodemailer.createTransport({host:process.env.SMTP_HOST,port:Number(process.env.SMTP_PORT||587),secure:Number(process.env.SMTP_PORT)===465,auth:{user:process.env.SMTP_USER,pass:process.env.SMTP_PASS}});await transport.sendMail({from:process.env.MAIL_FROM||process.env.SMTP_USER,to,subject,html})}catch(e){console.error('Email notification failed:',e.message)}}
app.get('/api/health',(req,res)=>res.json({ok:true}))
app.get('/api/artworks',(req,res)=>res.json({artworks:store.artworks}))
app.get('/api/categories',(req,res)=>res.json({categories:store.categories}))
app.get('/api/content',(req,res)=>res.json({content:store.content}))
app.post('/api/enquiries',async(req,res)=>{const {name,email,phone,message,type='contact'}=req.body;if(!name||!email||!message)return res.status(400).json({error:'Name, email and message are required.'});const item={id:crypto.randomUUID(),name,email,phone,message,type,createdAt:new Date().toISOString()};store.enquiries.unshift(item);save();await notify(`New ${type} from ${name}`,`<p><b>${name}</b> (${email})</p><p>${message}</p>`);res.status(201).json({ok:true})})
app.post('/api/orders',async(req,res)=>{
  const {name,email,phone,message,items,total}=req.body
  if(!name||!email||!Array.isArray(items)||!items.length)return res.status(400).json({error:'Please provide contact details and at least one artwork.'})
  let userId=null
  const token=(req.headers.authorization||'').replace(/^Bearer\s+/,'')
  if(token){try{const payload=jwt.verify(token,process.env.JWT_SECRET||'dev-only-change-this-secret');if(payload.userId)userId=payload.userId}catch{}}
  const now=new Date().toISOString(),number=nextOrderNumber(),id=crypto.randomUUID()
  db.prepare('INSERT INTO orders (id,number,user_id,customer_name,customer_email,customer_phone,message,items,total,status,created_at,updated_at) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)').run(id,number,userId,name,email,phone||null,message||null,JSON.stringify(items),Number(total||0),'pending',now,now)
  const item={id,name,email,phone,message,type:'order',items,total,status:'pending',number,createdAt:now}
  store.enquiries.unshift(item);save()
  await notify(`New order request #${number} from ${name}`,`<p>${name} · ${email}</p><p>${items.map(i=>`${i.title} × ${i.quantity}`).join('<br>')}</p><p>Total estimate: ₹${total||0}</p><p>${message||''}</p>`)
  res.status(201).json({ok:true,order:{id,number,status:'pending',createdAt:now}})
})
app.post('/api/auth/register',async(req,res)=>{
  const name=(req.body.name||'').trim(),email=(req.body.email||'').trim().toLowerCase(),password=req.body.password||''
  if(!name||!email||password.length<8)return res.status(400).json({error:'Name and a valid email are required, with a password of at least 8 characters.'})
  if(db.prepare('SELECT id FROM users WHERE email=?').get(email))return res.status(409).json({error:'An account with this email already exists.'})
  const id=crypto.randomUUID(),now=new Date().toISOString()
  db.prepare('INSERT INTO users (id,name,email,password_hash,role,created_at) VALUES (?,?,?,?,?,?)').run(id,name,email,await bcrypt.hash(password,10),'user',now)
  res.status(201).json({ok:true})
})
app.post('/api/auth/login',async(req,res)=>{
  const email=(req.body.email||'').trim().toLowerCase(),password=req.body.password||''
  const user=db.prepare('SELECT * FROM users WHERE email=?').get(email)
  if(!user||!await bcrypt.compare(password,user.password_hash))return res.status(401).json({error:'Incorrect email or password.'})
  const loginId=crypto.randomUUID(),now=new Date().toISOString()
  db.prepare('INSERT INTO login_records (id,user_id,logged_in_at,active,last_seen_at) VALUES (?,?,?,?,?)').run(loginId,user.id,now,1,now)
  const token=jwt.sign({userId:user.id,name:user.name,email:user.email,role:'user',loginId},process.env.JWT_SECRET||'dev-only-change-this-secret',{expiresIn:'12h'})
  res.json({token,user:{id:user.id,name:user.name,email:user.email}})
})
app.post('/api/auth/logout',userAuth,(req,res)=>{
  db.prepare('UPDATE login_records SET active=0,logged_out_at=? WHERE id=?').run(new Date().toISOString(),req.user.loginId)
  res.json({ok:true})
})
app.post('/api/auth/forgot-password',async(req,res)=>{
  const email=(req.body.email||'').trim().toLowerCase(),user=db.prepare('SELECT * FROM users WHERE email=?').get(email)
  if(user){
    const raw=crypto.randomBytes(32).toString('hex'),hash=crypto.createHash('sha256').update(raw).digest('hex')
    db.prepare('UPDATE users SET reset_token_hash=?,reset_expires=? WHERE id=?').run(hash,Date.now()+60*60*1000,user.id)
    await notify(`Password reset requested for ${user.name}`,`<p>Use this reset token: <b>${raw}</b></p><p>This token expires in 1 hour.</p>`)
  }
  res.json({ok:true,message:'If an account exists, password reset instructions have been sent.'})
})
app.post('/api/auth/reset-password',async(req,res)=>{
  const token=req.body.token||'',password=req.body.password||'',hash=crypto.createHash('sha256').update(token).digest('hex')
  const user=db.prepare('SELECT * FROM users WHERE reset_token_hash=? AND reset_expires>?').get(hash,Date.now())
  if(!user||password.length<8)return res.status(400).json({error:'The reset token is invalid or expired, or the password is too short.'})
  db.prepare('UPDATE users SET password_hash=?,reset_token_hash=NULL,reset_expires=NULL WHERE id=?').run(await bcrypt.hash(password,10),user.id)
  res.json({ok:true})
})
app.get('/api/auth/profile',userAuth,(req,res)=>{
  const user=db.prepare('SELECT id,name,email,created_at FROM users WHERE id=?').get(req.user.userId)
  if(!user)return res.status(404).json({error:'User not found.'})
  res.json({user})
})
app.put('/api/auth/profile',userAuth,(req,res)=>{
  const name=(req.body.name||'').trim()
  if(!name)return res.status(400).json({error:'Name is required.'})
  db.prepare('UPDATE users SET name=? WHERE id=?').run(name,req.user.userId)
  res.json({ok:true,user:{...req.user,name}})
})
app.get('/api/auth/orders',userAuth,(req,res)=>{
  const cutoff=new Date(Date.now()-30*60*1000).toISOString()
  db.prepare('UPDATE login_records SET last_seen_at=? WHERE id=?').run(new Date().toISOString(),req.user.loginId)
  const rows=db.prepare('SELECT * FROM orders WHERE user_id=? ORDER BY created_at DESC').all(req.user.userId)
  res.json({orders:rows.map(o=>({...o,items:JSON.parse(o.items)}))})
})
app.post('/api/admin/login',async(req,res)=>{const {username,password}=req.body;if(username!==store.admin.username||!await bcrypt.compare(password||'',store.admin.passwordHash))return res.status(401).json({error:'Incorrect username or password.'});const token=jwt.sign({username,role:'admin'},process.env.JWT_SECRET||'dev-only-change-this-secret',{expiresIn:'12h'});res.json({token,mustChange:store.admin.mustChange})})
app.get('/api/admin/dashboard',adminAuth,(req,res)=>{
  const cutoff=new Date(Date.now()-30*60*1000).toISOString()
  db.prepare('UPDATE login_records SET active=0 WHERE active=1 AND last_seen_at<?').run(cutoff)
  const stats={
    registeredUsers:db.prepare("SELECT COUNT(*) AS n FROM users WHERE role='user'").get().n,
    activeUsers:db.prepare('SELECT COUNT(DISTINCT user_id) AS n FROM login_records WHERE active=1').get().n,
    totalLogins:db.prepare('SELECT COUNT(*) AS n FROM login_records').get().n,
    totalOrders:db.prepare('SELECT COUNT(*) AS n FROM orders').get().n,
    pendingOrders:db.prepare("SELECT COUNT(*) AS n FROM orders WHERE status='pending'").get().n,
    completedOrders:db.prepare("SELECT COUNT(*) AS n FROM orders WHERE status='completed'").get().n
  }
  res.json({stats})
})
app.get('/api/admin/orders',adminAuth,(req,res)=>{
  const rows=db.prepare(`
    SELECT o.*, u.name AS account_name, u.email AS account_email
    FROM orders o LEFT JOIN users u ON u.id=o.user_id
    ORDER BY o.created_at DESC
  `).all()
  res.json({orders:rows.map(o=>({...o,items:JSON.parse(o.items)}))})
})
app.put('/api/admin/orders/:id/status',adminAuth,(req,res)=>{
  const status=req.body.status
  if(!['pending','processing','completed'].includes(status))return res.status(400).json({error:'Invalid order status.'})
  const order=db.prepare('SELECT * FROM orders WHERE id=?').get(req.params.id)
  if(!order)return res.status(404).json({error:'Order not found.'})
  const now=new Date().toISOString()
  db.prepare('UPDATE orders SET status=?,updated_at=? WHERE id=?').run(status,now,order.id)
  const updated=db.prepare('SELECT * FROM orders WHERE id=?').get(order.id)
  res.json({order:{...updated,items:JSON.parse(updated.items)}})
})
app.get('/api/admin/users',adminAuth,(req,res)=>{
  const users=db.prepare(`
    SELECT u.id,u.name,u.email,u.created_at,
      COUNT(DISTINCT o.id) AS order_count,
      MAX(l.logged_in_at) AS last_login
    FROM users u
    LEFT JOIN orders o ON o.user_id=u.id
    LEFT JOIN login_records l ON l.user_id=u.id
    GROUP BY u.id,u.name,u.email,u.created_at
    ORDER BY u.created_at DESC
  `).all()
  res.json({users})
})
app.get('/api/admin/enquiries',auth,(req,res)=>res.json({enquiries:store.enquiries}))
app.post('/api/admin/password',auth,async(req,res)=>{const {currentPassword,newPassword}=req.body;if(!await bcrypt.compare(currentPassword||'',store.admin.passwordHash))return res.status(400).json({error:'Current password is incorrect.'});if(!newPassword||newPassword.length<8)return res.status(400).json({error:'New password must be at least 8 characters.'});store.admin.passwordHash=await bcrypt.hash(newPassword,10);store.admin.mustChange=false;save();res.json({ok:true})})
app.delete('/api/admin/enquiries/:id',auth,(req,res)=>{
  const i=store.enquiries.findIndex(x=>x.id===req.params.id)
  if(i<0)return res.status(404).json({error:'Enquiry not found.'})
  store.enquiries.splice(i,1)
  save()
  res.json({ok:true})
})
app.post('/api/admin/artworks',auth,upload.single('image'),(req,res)=>{const {title,category,price,description,size}=req.body;if(!title||!category||price===undefined)return res.status(400).json({error:'Title, category and price are required.'});if(!req.file)return res.status(400).json({error:'Please choose an image.'});const art={id:crypto.randomUUID(),title,category,price:Number(price),description:description||'',size:size||'',image:`/uploads/${req.file.filename}`,featured:req.body.featured==='on'};store.artworks.unshift(art);save();res.status(201).json({artwork:art})})
app.put('/api/admin/artworks/:id',auth,upload.single('image'),(req,res)=>{const a=store.artworks.find(x=>x.id===req.params.id);if(!a)return res.status(404).json({error:'Artwork not found.'});Object.assign(a,{title:req.body.title||a.title,category:req.body.category||a.category,price:req.body.price!==undefined?Number(req.body.price):a.price,description:req.body.description??a.description,size:req.body.size??a.size,featured:req.body.featured==='on'});if(req.file){if(a.image?.startsWith('/uploads/'))fs.rmSync(path.join(uploadDir,path.basename(a.image)),{force:true});a.image=`/uploads/${req.file.filename}`}save();res.json({artwork:a})})
app.delete('/api/admin/artworks/:id',auth,(req,res)=>{const i=store.artworks.findIndex(x=>x.id===req.params.id);if(i<0)return res.status(404).json({error:'Artwork not found.'});const [a]=store.artworks.splice(i,1);if(a.image?.startsWith('/uploads/'))fs.rmSync(path.join(uploadDir,path.basename(a.image)),{force:true});save();res.json({ok:true})})
app.post('/api/admin/categories',auth,(req,res)=>{const name=(req.body.name||'').trim();if(!name)return res.status(400).json({error:'Category name is required.'});if(store.categories.some(c=>c.name.toLowerCase()===name.toLowerCase()))return res.status(409).json({error:'Category already exists.'});const c={id:crypto.randomUUID(),name};store.categories.push(c);save();res.status(201).json({category:c})})
app.delete('/api/admin/categories/:id',auth,(req,res)=>{const c=store.categories.find(x=>x.id===req.params.id);if(!c)return res.status(404).json({error:'Category not found.'});if(store.artworks.some(a=>a.category===c.name))return res.status(409).json({error:'Move artworks to another category before deleting this one.'});store.categories=store.categories.filter(x=>x.id!==c.id);save();res.json({ok:true})})
app.put('/api/admin/content',auth,(req,res)=>{store.content={...store.content,...req.body};save();res.json({content:store.content})})
app.use((err,req,res,next)=>{console.error(err);res.status(400).json({error:err.message||'Request failed.'})})
app.listen(PORT,()=>console.log(`Rohan / Mandala Art API running at http://localhost:${PORT}`))
