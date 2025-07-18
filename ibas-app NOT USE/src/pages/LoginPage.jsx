import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { InputText } from "primereact/inputtext";
import { Dropdown } from "primereact/dropdown";
import { Button } from "primereact/button";
import { useEffect } from "react";

export default function LoginPage() {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [division, setDivision] = useState(null);
  const [error, setError] = useState("");
  const navigate = useNavigate();

  const handleLogin = () => {
    if (username === "admin" && password === "123456") {
      localStorage.setItem("auth", "true");
      navigate("/main");
    } else {
      setError("Invalid username or password");
    }
  };

  const [hostInfo, setHostInfo] = useState({ hostname: "", localIPs: [] });

  useEffect(() => {
    fetch("http://localhost:8080/api/hostinfo")
      .then(res => res.json())
      .then(data => setHostInfo(data))
      .catch(() => setHostInfo({ hostname: "Error", localIPs: [] }));
  }, []);

  const divisions = [
    { name: "New York", code: "NY" },
    { name: "Rome", code: "RM" },
    { name: "London", code: "LDN" },
    { name: "Istanbul", code: "IST" },
    { name: "Paris", code: "PRS" },
  ];

  return (
    <div className="flex justify-content-center align-items-center h-screen surface-ground">
      <div className="card p-4 shadow-3 w-full sm:w-25rem">
        <h2 className="text-center mb-4">Login</h2>

        {error && <p className="text-red-500 mb-3">{error}</p>}

        <div className="field mb-3">
          <label htmlFor="username" className="text-left block mb-2">
            Username
          </label>
          <InputText
            id="username"
            className="w-full"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            placeholder="Enter username"
          />
        </div>

        <div className="field mb-3">
          <label htmlFor="password" className="text-left block mb-2">
            Password
          </label>
          <InputText
            id="password"
            type="password"
            className="w-full"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            placeholder="Enter password"
          />
        </div>

        <div className="field mb-4">
          <label htmlFor="division" className="text-left block mb-2">
            Division
          </label>
          <Dropdown
            inputId="division"
            value={division}
            onChange={(e) => setDivision(e.value)}
            options={divisions}
            optionLabel="name"
            optionValue="code"
            placeholder="Select Division"
            className="w-full"
            filter
            showClear
          />
        </div>

        <div className="field mb-3">
          <Button
            label="Login"
            icon="pi pi-sign-in"
            className="w-full"
            onClick={handleLogin}
          />
        </div>

        <p>Computer: {hostInfo.hostname}</p>
        <p>Local IP(s): {hostInfo.localIPs.join(", ")}</p>
      </div>
    </div>
  );
}
