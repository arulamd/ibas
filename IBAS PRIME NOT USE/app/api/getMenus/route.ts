import { NextRequest, NextResponse } from 'next/server';

export async function GET(req: NextRequest) {
  const { searchParams } = new URL(req.url);

  const usercode = searchParams.get('usercode');
  const companycode = searchParams.get('companycode');
  const divisioncode = searchParams.get('divisioncode');

  const baseUrl = process.env.NEXT_PUBLIC_API_BASE_URL; // <-- read from .env

  if (!baseUrl) {
    return NextResponse.json({ error: 'API_BASE_URL not defined in env' }, { status: 500 });
  }

  const backendUrl = `${baseUrl}/getMenus?usercode=${usercode}&companycode=${companycode}&divisioncode=${divisioncode}`;

  //const backendUrl = `http://localhost:7000/api/v1/getMenus?usercode=${usercode}&companycode=${companycode}&divisioncode=${divisioncode}`;

  try {
    const res = await fetch(backendUrl, {
      method: 'GET',
      headers: {
        Accept: 'application/json',
      },
    });

    if (!res.ok) {
      return NextResponse.json({ error: 'Failed to fetch data from Go backend' }, { status: res.status });
    }

    const data = await res.json();
    return NextResponse.json(data.data);
  } catch (error) {
    return NextResponse.json({ error: 'Internal error contacting backend' }, { status: 500 });
  }
}
