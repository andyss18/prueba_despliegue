<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sistema de Gestión Empresarial</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700;800&display=swap');
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            /* Imagen bajada un poco más (45%) */
            background: url('imagen/marian.jpeg') center top 10% / cover no-repeat fixed;
            min-height: 100vh;
            overflow-x: hidden;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            position: relative;
        }

        body::before {
            content: '';
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.25);
            z-index: -1;
        }

        /* Efecto de partículas sutiles en el fondo */
        body::after {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: 
                radial-gradient(circle at 20% 30%, rgba(255,255,255,0.1) 2px, transparent 0),
                radial-gradient(circle at 80% 70%, rgba(255,255,255,0.08) 1px, transparent 0);
            background-size: 50px 50px, 30px 30px;
            z-index: -1;
            animation: float 20s infinite linear;
        }

        @keyframes float {
            0% { transform: translate(0, 0); }
            100% { transform: translate(-50px, -50px); }
        }

        .top-corner {
            position: fixed;
            top: 30px;
            right: 40px;
            z-index: 1000;
        }

        .user-info {
            font-size: 1.1em;
            background: rgba(255, 255, 255, 0.2);
            color: white;
            padding: 12px 25px;
            border-radius: 35px;
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            box-shadow: 0 6px 25px rgba(0,0,0,0.25);
            text-shadow: 0 2px 6px rgba(0,0,0,0.3);
            letter-spacing: 0.5px;
            position: relative;
            overflow: hidden;
        }

        .user-info::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .user-info:hover::before {
            left: 100%;
        }

        .glass-container {
            width: 90%;
            max-width: 850px;
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(35px);
            border-radius: 25px;
            padding: 40px;
            margin-top: 120px;
            box-shadow: 
                0 25px 60px rgba(0,0,0,0.25),
                inset 0 1px 0 rgba(255,255,255,0.1);
            border: 1px solid rgba(255, 255, 255, 0.15);
            animation: appear 1s ease-out;
            position: relative;
        }

        /* Efecto de borde luminoso sutil */
        .glass-container::before {
            content: '';
            position: absolute;
            top: -1px;
            left: -1px;
            right: -1px;
            bottom: -1px;
            background: linear-gradient(45deg, rgba(255,255,255,0.1), rgba(255,255,255,0.05), rgba(255,255,255,0.1));
            border-radius: 26px;
            z-index: -1;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .glass-container:hover::before {
            opacity: 1;
        }

        @keyframes appear {
            from {
                transform: translateY(40px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        .main-menu {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
        }

        .main-btn {
            background: rgba(255, 255, 255, 0.1);
            color: white;
            padding: 35px 15px;
            border-radius: 18px;
            font-size: 1.2em;
            font-weight: 700;
            border: none;
            cursor: pointer;
            text-align: center;
            position: relative;
            overflow: hidden;
            transition: all 0.4s ease;
            box-shadow: 
                0 12px 30px rgba(0,0,0,0.25),
                inset 0 1px 0 rgba(255,255,255,0.1);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .main-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
            transition: left 0.6s;
        }

        .main-btn:hover::before {
            left: 100%;
        }

        .main-btn:hover {
            transform: translateY(-5px) scale(1.03);
            background: rgba(255, 255, 255, 0.18);
            box-shadow: 
                0 18px 40px rgba(0,0,0,0.3),
                inset 0 1px 0 rgba(255,255,255,0.15);
        }

        .menu-icon {
            font-size: 2.5em;
            display: block;
            margin-bottom: 10px;
            filter: drop-shadow(0 4px 8px rgba(0,0,0,0.4));
            transition: transform 0.3s ease;
        }

        .main-btn:hover .menu-icon {
            transform: scale(1.1) rotate(5deg);
        }

        .submenu-container {
            display: none;
            grid-column: 1 / -1;
            margin-top: 15px;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(25px);
            border-radius: 18px;
            border: 1px solid rgba(255, 255, 255, 0.15);
            padding: 25px;
            animation: slideDown 0.4s ease;
            box-shadow: 
                inset 0 1px 0 rgba(255,255,255,0.1),
                0 8px 25px rgba(0,0,0,0.2);
        }

        @keyframes slideDown {
            from { transform: translateY(-10px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        .submenu-title {
            font-weight: 700;
            color: white;
            margin-bottom: 15px;
            font-size: 1.2em;
            text-shadow: 0 2px 6px rgba(0,0,0,0.4);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .submenu-item {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            color: white;
            padding: 14px 20px;
            margin: 8px 0;
            border-radius: 12px;
            font-weight: 600;
            border: 1px solid rgba(255, 255, 255, 0.1);
            background: rgba(255, 255, 255, 0.08);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .submenu-item::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            height: 100%;
            width: 3px;
            background: linear-gradient(to bottom, rgba(255,255,255,0.5), transparent);
            transform: scaleY(0);
            transition: transform 0.3s ease;
        }

        .submenu-item:hover::before {
            transform: scaleY(1);
        }

        .submenu-item:hover {
            background: rgba(255, 255, 255, 0.18);
            transform: translateX(8px);
            padding-left: 25px;
        }

        .nested-submenu {
            margin-left: 20px;
            padding-left: 15px;
            border-left: 2px solid rgba(255, 255, 255, 0.15);
        }

        /* Efecto de brillo al hacer hover en enlaces del submenú */
        .submenu-item:hover {
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }

        @media (max-width: 768px) {
            .glass-container {
                padding: 25px;
                margin-top: 80px;
            }

            .main-menu {
                grid-template-columns: 1fr;
                gap: 15px;
            }

            .user-info {
                font-size: 1em;
                padding: 10px 18px;
            }
        }
        /* 🌙 Menú lateral expandible con submenús */
        .sidebar {
            position: fixed;
            left: -260px;
            top: 0;
            width: 250px;
            height: 100%;
            background: rgba(0, 0, 0, 0.75);
            backdrop-filter: blur(15px);
            transition: left 0.4s ease;
            padding-top: 80px;
            z-index: 2000;
            border-right: 1px solid rgba(255, 255, 255, 0.15);
            box-shadow: 4px 0 25px rgba(0, 0, 0, 0.4);
        }

        .sidebar.active {
            left: 0;
        }

        .sidebar-menu {
            list-style: none;
            padding: 0 10px;
            margin: 0;
        }

        .sidebar-menu li {
            margin: 10px 0;
        }

        .sidebar-menu a,
        .dropdown-btn {
            color: white;
            text-decoration: none;
            font-weight: 600;
            font-size: 1.05em;
            display: block;
            padding: 12px 18px;
            border-radius: 10px;
            transition: all 0.3s ease;
            background: transparent;
            border: none;
            width: 100%;
            text-align: left;
            cursor: pointer;
        }

        .sidebar-menu a:hover,
        .dropdown-btn:hover {
            background: rgba(255, 255, 255, 0.15);
            transform: translateX(5px);
        }

        /* Submenús desplegables */
        .dropdown-container {
            display: none;
            background: rgba(255, 255, 255, 0.1);
            border-left: 2px solid rgba(255, 255, 255, 0.2);
            margin-left: 10px;
            border-radius: 10px;
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .dropdown-container li {
            margin: 5px 0;
        }

        .dropdown-container a {
            font-size: 0.95em;
            padding: 10px 25px;
        }

        .dropdown-container a:hover {
            background: rgba(255, 255, 255, 0.18);
        }

        /* Icono de hamburguesa */
        .hamburger {
            position: fixed;
            top: 25px;
            left: 25px;
            width: 35px;
            height: 30px;
            cursor: pointer;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            z-index: 3000;
        }

        .hamburger span {
            height: 4px;
            width: 100%;
            background: white;
            border-radius: 10px;
            transition: all 0.4s ease;
        }

        .hamburger.active span:nth-child(1) {
            transform: rotate(45deg) translate(6px, 7px);
        }

        .hamburger.active span:nth-child(2) {
            opacity: 0;
        }

        .hamburger.active span:nth-child(3) {
            transform: rotate(-45deg) translate(7px, -8px);
        }

        /* Oscurecer fondo cuando el menú está activo */
        body.menu-open::before {
            content: '';
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.5);
            z-index: 1500;
        }

        /* Flecha de submenú (simulada) */
        .dropdown-btn::after {
            content: '▸';
            float: right;
            transition: transform 0.3s ease;
            font-size: 0.9em;
        }

        .dropdown-btn.active::after {
            transform: rotate(90deg);
        }
        .sidebar-menu li:first-child a {
            background: rgba(255, 255, 255, 0.15);
            font-weight: 700;
        }
        .sidebar-menu li:first-child a:hover {
            background: rgba(255, 255, 255, 0.25);
        }
    </style>
</head>
<%
    String permiso = request.getParameter("permiso");
    if ("denegado".equals(permiso)) {
%>
<script>
    alert("🚫 No tienes permiso para acceder a esta sección.");
</script>
<%
    }
%>
<body>
    <!-- 🌟 Menú lateral con submenús -->
    <div class="sidebar" id="sidebar">
        <ul class="sidebar-menu">
            <li>
                <a href="${pageContext.request.contextPath}/index.jsp">🏠 Inicio</a>
            </li>
            <li>
                <button class="dropdown-btn">📦 Productos</button>
                <ul class="dropdown-container">
                    <li><a href="${pageContext.request.contextPath}/productos.jsp">Gestión de Productos</a></li>
                    <li><a href="${pageContext.request.contextPath}/ADMIN/marcas.jsp">Gestión de Marcas</a></li>
                </ul>
            </li>

            <li>
                <button class="dropdown-btn">💰 Ventas</button>
                <ul class="dropdown-container">
                    <li><a href="${pageContext.request.contextPath}/ventas.jsp">Gestión de Ventas</a></li>
                    <li><a href="${pageContext.request.contextPath}/clientes.jsp">Gestión de Clientes</a></li>
                    <li><a href="${pageContext.request.contextPath}/ADMIN/empleados.jsp">Gestión de Empleados</a></li>
                    <li><a href="${pageContext.request.contextPath}/ADMIN/puestos.jsp">Gestión de Puestos</a></li>
                </ul>
            </li>

            <li>
                <button class="dropdown-btn">🛒 Compras</button>
                <ul class="dropdown-container">
                    <li><a href="${pageContext.request.contextPath}/compras.jsp">Gestión de Compras</a></li>
                    <li><a href="${pageContext.request.contextPath}/ADMIN/proveedores.jsp">Gestión de Proveedores</a></li>
                </ul>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/reporte.jsp">📊 Reportes</a>
            </li>
        </ul>
    </div>

    <!-- Botón de tres líneas -->
    <div class="hamburger" id="hamburger">
        <span></span>
        <span></span>
        <span></span>
    </div>
    <%
        HttpSession sesion = request.getSession(false);
        if (sesion == null || sesion.getAttribute("usuario") == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        Usuario u = (Usuario) sesion.getAttribute("usuario");
    %>

    <div class="top-corner">
        <div class="user-info">
            Bienvenido, <strong><%= u.getUsername() %></strong>
        </div>
    </div>

    <div class="glass-container">
        <div class="main-menu">
            <button class="main-btn" onclick="toggleSubmenu('submenu-productos')">
                <span class="menu-icon">📦</span> Productos
            </button>

            <button class="main-btn" onclick="toggleSubmenu('submenu-ventas')">
                <span class="menu-icon">💰</span> Ventas
            </button>

            <button class="main-btn" onclick="toggleSubmenu('submenu-compras')">
                <span class="menu-icon">🛒</span> Compras
            </button>

            <a href="${pageContext.request.contextPath}/reporte.jsp" class="main-btn">
                <span class="menu-icon">📊</span> Reportes
            </a>

            <div id="submenu-productos" class="submenu-container">
                <div class="submenu-title">📦 Opciones de Productos</div>
                <a href="${pageContext.request.contextPath}/productos.jsp" class="submenu-item">📦 Gestión de Productos</a>
                <a href="${pageContext.request.contextPath}/ADMIN/marcas.jsp" class="submenu-item">🏷️ Gestión de Marcas</a>
            </div>

            <div id="submenu-ventas" class="submenu-container">
                <div class="submenu-title">💰 Opciones de Ventas</div>
                <a href="${pageContext.request.contextPath}/ventas.jsp" class="submenu-item">💰 Gestión de Ventas</a>
                <a href="${pageContext.request.contextPath}/clientes.jsp" class="submenu-item">👥 Gestión de Clientes</a>
                <a href="${pageContext.request.contextPath}/ADMIN/empleados.jsp" class="submenu-item">👨‍💼 Gestión de Empleados</a>
                <div class="nested-submenu">
                    <a href="${pageContext.request.contextPath}/ADMIN/puestos.jsp" class="submenu-item">💼 Gestión de Puestos</a>
                </div>
            </div>

            <div id="submenu-compras" class="submenu-container">
                <div class="submenu-title">🛒 Opciones de Compras</div>
                <a href="${pageContext.request.contextPath}/compras.jsp" class="submenu-item">🛒 Gestión de Compras</a>
                <a href="${pageContext.request.contextPath}/ADMIN/proveedores.jsp" class="submenu-item">🏢 Gestión de Proveedores</a>
            </div>
        </div>
    </div>

    <script>
        let submenuAbierto = null;

        function toggleSubmenu(id) {
            const submenu = document.getElementById(id);

            if (submenuAbierto && submenuAbierto !== submenu) {
                submenuAbierto.style.display = 'none';
            }

            if (submenu.style.display === 'block') {
                submenu.style.display = 'none';
                submenuAbierto = null;
            } else {
                submenu.style.display = 'block';
                submenuAbierto = submenu;
            }
        }

        document.addEventListener('click', function (event) {
            if (!event.target.closest('.main-btn') && !event.target.closest('.submenu-container')) {
                const submenus = document.querySelectorAll('.submenu-container');
                submenus.forEach(submenu => submenu.style.display = 'none');
                submenuAbierto = null;
            }
        });
    const sidebar = document.getElementById("sidebar");
    const hamburger = document.getElementById("hamburger");
    const dropdownButtons = document.querySelectorAll(".dropdown-btn");

    hamburger.addEventListener("click", () => {
        sidebar.classList.toggle("active");
        hamburger.classList.toggle("active");
        document.body.classList.toggle("menu-open");
    });

    // Cierra menú al hacer clic fuera
    document.addEventListener("click", (e) => {
        if (!sidebar.contains(e.target) && !hamburger.contains(e.target)) {
            sidebar.classList.remove("active");
            hamburger.classList.remove("active");
            document.body.classList.remove("menu-open");
            dropdownButtons.forEach(btn => {
                btn.classList.remove("active");
                btn.nextElementSibling.style.display = "none";
            });
        }
    });

    // Submenús desplegables
    dropdownButtons.forEach(btn => {
        btn.addEventListener("click", () => {
            const dropdown = btn.nextElementSibling;
            const isOpen = dropdown.style.display === "block";

            // Cierra otros submenús
            document.querySelectorAll(".dropdown-container").forEach(dc => dc.style.display = "none");
            document.querySelectorAll(".dropdown-btn").forEach(b => b.classList.remove("active"));

            if (!isOpen) {
                dropdown.style.display = "block";
                btn.classList.add("active");
            }
        });
    });
        
    </script>
</body>

</html>