import { useState } from 'react';
import { Sidebar } from 'primereact/sidebar';
import TopHeader from './TopHeader';
import SideMenu from './SideMenu';
import Footer from './Footer';
import { Outlet } from 'react-router-dom';

export default function AppLayout() {
  const [sidebarVisible, setSidebarVisible] = useState(false);

  return (
    <div className="flex flex-column min-h-screen">
      <TopHeader onMenuClick={() => setSidebarVisible(true)} />

      {/* Sidebar for mobile */}
      <Sidebar visible={sidebarVisible} onHide={() => setSidebarVisible(false)} className="w-18rem">
        <SideMenu />
      </Sidebar>

      {/* Sidebar for desktop */}
      <div className="flex flex-grow-1">
        <SideMenu />

        {/* Main Content */}
        <main className="flex-grow-1 p-4">
          <Outlet />
        </main>
      </div>

      <Footer />
    </div>
  );
}
