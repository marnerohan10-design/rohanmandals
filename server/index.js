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
dotenv.config()
const __dirname=path.dirname(fileURLToPath(import.meta.url))
const app=express(),PORT=process.env.PORT||4000
const dataDir=path.join(__dirname,'data'),uploadDir=path.join(__dirname,'uploads')
fs.mkdirSync(dataDir,{recursive:true});fs.mkdirSync(uploadDir,{recursive:true})
const dbFile=path.join(dataDir,'store.json')
const seed={artworks:[
{id:'a1',title:'The Quiet Bloom',category:'Floral',price:2400,description:'A delicate study of balance, patience and the beauty of small beginnings.',size:'A4 · Original artwork',image:'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?w=900&q=85',featured:true},
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
const auth=(req,res,next)=>{try{const token=(req.headers.authorization||'').replace(/^Bearer\s+/,'');req.admin=jwt.verify(token,process.env.JWT_SECRET||'dev-only-change-this-secret');next()}catch{return res.status(401).json({error:'Please sign in again.'})}}
async function notify(subject,html){const to=process.env.NOTIFY_EMAIL;if(!to){console.log(`\n[NEW ENQUIRY] ${subject}\n${html}\n`);return}if(!process.env.SMTP_HOST){console.log('[EMAIL NOT SENT] Configure SMTP_HOST and SMTP credentials in server/.env');return}try{const transport=nodemailer.createTransport({host:process.env.SMTP_HOST,port:Number(process.env.SMTP_PORT||587),secure:Number(process.env.SMTP_PORT)===465,auth:{user:process.env.SMTP_USER,pass:process.env.SMTP_PASS}});await transport.sendMail({from:process.env.MAIL_FROM||process.env.SMTP_USER,to,subject,html})}catch(e){console.error('Email notification failed:',e.message)}}
app.get('/api/health',(req,res)=>res.json({ok:true}))
app.get('/api/artworks',(req,res)=>res.json({artworks:store.artworks}))
app.get('/api/categories',(req,res)=>res.json({categories:store.categories}))
app.get('/api/content',(req,res)=>res.json({content:store.content}))
app.post('/api/enquiries',async(req,res)=>{const {name,email,phone,message,type='contact'}=req.body;if(!name||!email||!message)return res.status(400).json({error:'Name, email and message are required.'});const item={id:crypto.randomUUID(),name,email,phone,message,type,createdAt:new Date().toISOString()};store.enquiries.unshift(item);save();await notify(`New ${type} from ${name}`,`<p><b>${name}</b> (${email})</p><p>${message}</p>`);res.status(201).json({ok:true})})
app.post('/api/orders',async(req,res)=>{const {name,email,phone,message,items,total}=req.body;if(!name||!email||!Array.isArray(items)||!items.length)return res.status(400).json({error:'Please provide contact details and at least one artwork.'});const item={id:crypto.randomUUID(),name,email,phone,message,type:'order',items,total,createdAt:new Date().toISOString()};store.enquiries.unshift(item);save();await notify(`New order request from ${name}`,`<p>${name} · ${email}</p><p>${items.map(i=>`${i.title} × ${i.quantity}`).join('<br>')}</p><p>Total estimate: ₹${total||0}</p><p>${message||''}</p>`);res.status(201).json({ok:true})})
app.post('/api/admin/login',async(req,res)=>{const {username,password}=req.body;if(username!==store.admin.username||!await bcrypt.compare(password||'',store.admin.passwordHash))return res.status(401).json({error:'Incorrect username or password.'});const token=jwt.sign({username},process.env.JWT_SECRET||'dev-only-change-this-secret',{expiresIn:'12h'});res.json({token,mustChange:store.admin.mustChange})})
app.get('/api/admin/enquiries',auth,(req,res)=>res.json({enquiries:store.enquiries}))
app.post('/api/admin/password',auth,async(req,res)=>{const {currentPassword,newPassword}=req.body;if(!await bcrypt.compare(currentPassword||'',store.admin.passwordHash))return res.status(400).json({error:'Current password is incorrect.'});if(!newPassword||newPassword.length<8)return res.status(400).json({error:'New password must be at least 8 characters.'});store.admin.passwordHash=await bcrypt.hash(newPassword,10);store.admin.mustChange=false;save();res.json({ok:true})})
app.post('/api/admin/artworks',auth,upload.single('image'),(req,res)=>{const {title,category,price,description,size}=req.body;if(!title||!category||price===undefined)return res.status(400).json({error:'Title, category and price are required.'});if(!req.file)return res.status(400).json({error:'Please choose an image.'});const art={id:crypto.randomUUID(),title,category,price:Number(price),description:description||'',size:size||'',image:`/uploads/${req.file.filename}`,featured:req.body.featured==='on'};store.artworks.unshift(art);save();res.status(201).json({artwork:art})})
app.put('/api/admin/artworks/:id',auth,upload.single('image'),(req,res)=>{const a=store.artworks.find(x=>x.id===req.params.id);if(!a)return res.status(404).json({error:'Artwork not found.'});Object.assign(a,{title:req.body.title||a.title,category:req.body.category||a.category,price:req.body.price!==undefined?Number(req.body.price):a.price,description:req.body.description??a.description,size:req.body.size??a.size,featured:req.body.featured==='on'});if(req.file){if(a.image?.startsWith('/uploads/'))fs.rmSync(path.join(uploadDir,path.basename(a.image)),{force:true});a.image=`/uploads/${req.file.filename}`}save();res.json({artwork:a})})
app.delete('/api/admin/artworks/:id',auth,(req,res)=>{const i=store.artworks.findIndex(x=>x.id===req.params.id);if(i<0)return res.status(404).json({error:'Artwork not found.'});const [a]=store.artworks.splice(i,1);if(a.image?.startsWith('/uploads/'))fs.rmSync(path.join(uploadDir,path.basename(a.image)),{force:true});save();res.json({ok:true})})
app.post('/api/admin/categories',auth,(req,res)=>{const name=(req.body.name||'').trim();if(!name)return res.status(400).json({error:'Category name is required.'});if(store.categories.some(c=>c.name.toLowerCase()===name.toLowerCase()))return res.status(409).json({error:'Category already exists.'});const c={id:crypto.randomUUID(),name};store.categories.push(c);save();res.status(201).json({category:c})})
app.delete('/api/admin/categories/:id',auth,(req,res)=>{const c=store.categories.find(x=>x.id===req.params.id);if(!c)return res.status(404).json({error:'Category not found.'});if(store.artworks.some(a=>a.category===c.name))return res.status(409).json({error:'Move artworks to another category before deleting this one.'});store.categories=store.categories.filter(x=>x.id!==c.id);save();res.json({ok:true})})
app.put('/api/admin/content',auth,(req,res)=>{store.content={...store.content,...req.body};save();res.json({content:store.content})})
app.use((err,req,res,next)=>{console.error(err);res.status(400).json({error:err.message||'Request failed.'})})
app.listen(PORT,()=>console.log(`Rohan / Mandala Art API running at http://localhost:${PORT}`))
