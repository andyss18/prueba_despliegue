<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html>
<head>
    <meta charset="UTF-8">
    <title>Reportería - Sistema de Gestión Empresarial</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700;800&display=swap');


    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: 'Poppins', sans-serif;
        background: url('imagen/marian.jpeg') center top 10% / cover no-repeat fixed;
        min-height: 100vh;
        display: flex;
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

    .glass-container {
        width: 90%;
        max-width: 900px;
        background: rgba(255, 255, 255, 0.08);
        backdrop-filter: blur(30px);
        border-radius: 25px;
        padding: 50px 40px;
        box-shadow: 
            0 25px 60px rgba(0,0,0,0.25),
            inset 0 1px 0 rgba(255,255,255,0.1);
        border: 1px solid rgba(255, 255, 255, 0.15);
        animation: appear 1s ease-out;
        position: relative;
        text-align: center;
    }

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

    .report-title {
        color: white;
        font-size: 2.3em;
        font-weight: 700;
        margin-bottom: 10px;
        text-shadow: 0 4px 12px rgba(0,0,0,0.4);
    }

    .report-subtitle {
        color: rgba(255, 255, 255, 0.85);
        font-size: 1.1em;
        margin-bottom: 40px;
    }

    .report-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        gap: 25px;
    }

    .report-card {
        background: rgba(255, 255, 255, 0.12);
        border-radius: 18px;
        padding: 25px;
        color: white;
        text-decoration: none;
        font-weight: 600;
        font-size: 1.1em;
        border: 1px solid rgba(255, 255, 255, 0.15);
        transition: all 0.4s ease;
        position: relative;
        overflow: hidden;
        box-shadow: 
            0 12px 30px rgba(0,0,0,0.25),
            inset 0 1px 0 rgba(255,255,255,0.1);
    }

    .report-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
        transition: left 0.6s;
    }

    .report-card:hover::before {
        left: 100%;
    }

    .report-card:hover {
        transform: translateY(-6px);
        background: rgba(255, 255, 255, 0.2);
        box-shadow: 
            0 18px 40px rgba(0,0,0,0.3),
            inset 0 1px 0 rgba(255,255,255,0.15);
    }

    .icon {
        font-size: 2.2em;
        display: block;
        margin-bottom: 10px;
    }

    .back-btn {
        display: inline-block;
        margin-top: 40px;
        padding: 12px 25px;
        background: rgba(255,255,255,0.15);
        color: white;
        border-radius: 12px;
        font-weight: 600;
        text-decoration: none;
        transition: all 0.3s ease;
        border: 1px solid rgba(255,255,255,0.2);
    }

    .back-btn:hover {
        background: rgba(255,255,255,0.25);
        transform: translateY(-3px);
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
    <div class="glass-container">
        <h1 class="report-title">📊 REPORTERÍA</h1>
        <p class="report-subtitle">Seleccione el reporte que desea visualizar o exportar en PDF</p>

    <div class="report-grid">
        <!-- 💡 Aquí colocas tus enlaces a los servlets o JSP de reportes -->
        <a href="${pageContext.request.contextPath}/ReporteExistenciasPDF" class="report-card">
            <span class="icon">📦</span>
            Productos en Stock
        </a>

        <a href="reporteEmpleados" class="report-card">
            <span class="icon">👨‍💼</span>
            Empleados
        </a>

        <a href="reporteVentas" class="report-card">
            <span class="icon">💰</span>
            Ventas
        </a>

        <a href="reporteCompras" class="report-card">
            <span class="icon">🛒</span>
            Compras Registradas
        </a>

        <a href="reporteClientes" class="report-card">
            <span class="icon">👥</span>
            Clientes Frecuentes
        </a>
    </div>

    <!-- 🔙 BOTÓN DE REGRESO AL INICIO -->
    <a href="index.jsp" class="back-btn">⬅ Regresar al Menú Principal</a>
</div>
<script>
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
