import { Avatar } from 'primereact/avatar';
import { Button } from 'primereact/button';
import { useNavigate } from 'react-router-dom';

export default function TopHeader({ onMenuClick }) {
  const navigate = useNavigate();

  const handleLogout = () => {
    localStorage.removeItem("auth");
    navigate("/login");
  };

  return (
    <header className="flex justify-content-between align-items-center p-3 surface-100">
      <div className="flex align-items-center gap-3">
        <Button icon="pi pi-bars" className="p-button-text" onClick={onMenuClick} />
        <h2 className="m-0 text-xl">My Dashboard</h2>
      </div>

      <div className="flex align-items-center gap-3">
        <span className="font-medium">admin</span>
        <Avatar icon="pi pi-user" shape="circle" />
        <Button
          label="Logout"
          icon="pi pi-sign-out"
          className="p-button-text p-button-danger"
          onClick={handleLogout}
        />
      </div>
    </header>
  );
}
