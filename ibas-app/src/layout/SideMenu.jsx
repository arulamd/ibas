import { PanelMenu } from 'primereact/panelmenu';
import { useNavigate } from 'react-router-dom';

export default function SideMenu() {
  const navigate = useNavigate();

  const items = [
    {
      label: 'Dashboard',
      icon: 'pi pi-home',
      command: () => navigate('/main/dashboard'),
    },
    {
      label: 'Reports',
      icon: 'pi pi-chart-line',
      command: () => navigate('/reports'),
    },
  ];

  return (
    <aside className="p-3 surface-200 shadow-1 min-h-screen w-18rem hidden md:block">
      <PanelMenu model={items} className="w-full" />
    </aside>
  );
}
