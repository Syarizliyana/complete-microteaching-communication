import { NextResponse } from 'next/server'; import { sql } from '@/lib/db';
export async function GET(){try{const r=await sql`SELECT current_database() AS database, NOW() AS server_time`;return NextResponse.json({success:true,...r[0]});}catch{return NextResponse.json({success:false,error:'Database connection failed'},{status:500});}}
