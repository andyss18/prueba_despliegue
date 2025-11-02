<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="modelo.Marca"%>
<%@page import="modelo.Usuario"%>
<%
    List<Marca> listaMarcas = (List<Marca>) request.getAttribute("listaMarcas");
    Marca marca = (Marca) request.getAttribute("marca");
    Boolean mostrarTabla = (Boolean) request.getAttribute("mostrarTabla");
    Boolean mostrarFormulario = (Boolean) request.getAttribute("mostrarFormulario");
    Boolean esEdicion = (Boolean) request.getAttribute("esEdicion");
    String error = (String) request.getAttribute("error");
    
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("usuario") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestión de Marcas - Sistema Empresarial</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700;800&display=swap');
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: url('/Proyecto_final/imagen/marian.jpeg') center top 10% / cover no-repeat fixed;
            min-height: 100vh;
            overflow-x: hidden;
            display: flex;
            flex-direction: column;
            align-items: center;
            position: relative;
            padding: 20px;
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

        .top-nav {
            width: 90%;
            max-width: 1200px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .nav-brand {
            font-size: 1.5em;
            font-weight: 700;
            color: white;
            text-decoration: none;
            text-shadow: 0 2px 6px rgba(0,0,0,0.4);
        }

        .nav-menu {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .nav-link {
            color: white;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 500;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .nav-link:hover, .nav-link.active {
            background: rgba(255, 255, 255, 0.25);
            color: white;
            text-decoration: none;
        }

        .glass-container {
            width: 90%;
            max-width: 1200px;
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(35px);
            border-radius: 25px;
            padding: 40px;
            box-shadow: 
                0 25px 60px rgba(0,0,0,0.25),
                inset 0 1px 0 rgba(255,255,255,0.1);
            border: 1px solid rgba(255, 255, 255, 0.15);
            margin-bottom: 30px;
        }

        .section-title {
            color: white;
            font-size: 2em;
            font-weight: 700;
            margin-bottom: 30px;
            text-shadow: 0 2px 6px rgba(0,0,0,0.4);
            text-align: center;
        }

        .button-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }

        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-info {
            background: rgba(23, 162, 184, 0.8);
            color: white;
        }

        .btn-success {
            background: rgba(40, 167, 69, 0.8);
            color: white;
        }

        .btn-secondary {
            background: rgba(108, 117, 125, 0.8);
            color: white;
        }

        .btn-warning {
            background: rgba(255, 193, 7, 0.9);
            color: black;
        }

        .btn-danger {
            background: rgba(220, 53, 69, 0.8);
            color: white;
            padding: 8px 15px;
            font-size: 0.9em;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.3);
        }

        .error-message {
            background: rgba(220, 53, 69, 0.2);
            color: #ff6b6b;
            padding: 15px 20px;
            border-radius: 12px;
            text-align: center;
            margin: 20px 0;
            border: 1px solid rgba(220, 53, 69, 0.3);
            font-weight: 500;
            text-shadow: 0 1px 2px rgba(0,0,0,0.3);
            backdrop-filter: blur(10px);
        }

        .form-container {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(25px);
            border-radius: 18px;
            padding: 30px;
            border: 1px solid rgba(255, 255, 255, 0.15);
            margin-bottom: 30px;
        }

        .form-title {
            color: white;
            font-size: 1.5em;
            font-weight: 700;
            margin-bottom: 25px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.4);
            text-align: center;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            color: white;
            font-weight: 600;
            margin-bottom: 10px;
            display: block;
            text-shadow: 0 1px 3px rgba(0,0,0,0.4);
        }

        .form-input {
            width: 100%;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            padding: 12px 15px;
            color: white;
            font-size: 1em;
            backdrop-filter: blur(10px);
            transition: all 0.3s ease;
        }

        .form-input:focus {
            outline: none;
            background: rgba(255, 255, 255, 0.15);
            border-color: rgba(255, 255, 255, 0.4);
            box-shadow: 0 0 0 3px rgba(255,255,255,0.1);
        }

        .form-input::placeholder {
            color: rgba(255, 255, 255, 0.6);
        }

        .table-container {
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(25px);
            border-radius: 18px;
            padding: 25px;
            border: 1px solid rgba(255, 255, 255, 0.15);
        }

        .table-title {
            color: white;
            font-size: 1.5em;
            font-weight: 700;
            margin-bottom: 20px;
            text-shadow: 0 2px 6px rgba(0,0,0,0.4);
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            color: white;
        }

        .data-table th {
            background: rgba(255, 255, 255, 0.15);
            padding: 15px;
            text-align: left;
            font-weight: 600;
            border-bottom: 2px solid rgba(255, 255, 255, 0.2);
        }

        .data-table td {
            padding: 12px 15px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .data-table tr:hover td {
            background: rgba(255, 255, 255, 0.08);
        }

        .id-column {
            width: 80px;
            text-align: center;
        }

        .actions-column {
            width: 200px;
            text-align: center;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
            justify-content: center;
        }

        @media (max-width: 768px) {
            .glass-container {
                padding: 25px;
            }
            
            .nav-menu {
                flex-direction: column;
                gap: 5px;
            }
            
            .top-nav {
                flex-direction: column;
                gap: 15px;
            }
            
            .button-group {
                flex-direction: column;
                align-items: center;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .data-table {
                font-size: 0.9em;
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
    <div class="top-nav">
        <a href="${pageContext.request.contextPath}/index.jsp" class="nav-brand">
            <i class="fas fa-store me-2"></i>Sistema Empresarial
        </a>
        <div class="nav-menu">
            <a href="${pageContext.request.contextPath}/ADMIN/puestos.jsp" class="nav-link">Puestos</a>
            <a href="${pageContext.request.contextPath}/ADMIN/empleados.jsp" class="nav-link">Empleados</a>
            <a href="${pageContext.request.contextPath}/clientes.jsp" class="nav-link">Clientes</a>
            <a href="${pageContext.request.contextPath}/ADMIN/proveedores.jsp" class="nav-link">Proveedores</a>
            <a href="${pageContext.request.contextPath}/ADMIN/marcas.jsp" class="nav-link active">Marcas</a>
            <a href="${pageContext.request.contextPath}/ADMIN/productos.jsp" class="nav-link">Productos</a>
            <a href="${pageContext.request.contextPath}/compras.jsp" class="nav-link">Compras</a>
        </div>

    <div class="glass-container">
        <h1 class="section-title">Gestión de Marcas</h1>
        
        <div class="button-group">
            <a href="${pageContext.request.contextPath}/sr_marca?action=mostrar" class="btn btn-info">
                <i class="fas fa-list me-2"></i>Mostrar Marcas
            </a>
            <a href="${pageContext.request.contextPath}/sr_marca?action=agregar" class="btn btn-success">  
                <i class="fas fa-plus me-2"></i>Agregar Marca
            </a>
            <a href="${pageContext.request.contextPath}/productos.jsp" class="btn btn-secondary">
                <i class="fas fa-cube me-2"></i>Ir a Productos
            </a>
        </div>

        <% if (error != null && !error.isEmpty()) { %>
            <div class="error-message">
                <i class="fas fa-exclamation-triangle me-2"></i><%= error %>
            </div>
        <% } %>

        <% if (mostrarFormulario != null && mostrarFormulario) { %>
        <!-- Formulario de Marca -->
        <div class="form-container">
            <h2 class="form-title">
                <%= esEdicion != null && esEdicion ? "✏️ Actualizar Marca" : "➕ Agregar Marca" %>
            </h2>
            <form action="${pageContext.request.contextPath}/sr_marca" method="post">
                <% if (esEdicion != null && esEdicion) { %>
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="<%= marca.getIdmarca() %>">
                <% } else { %>
                    <input type="hidden" name="action" value="insert">
                <% } %>
                
                <div class="form-group">
                    <label for="marca" class="form-label">Nombre de la Marca *</label>
                    <input type="text" id="marca" name="marca" class="form-input"
                           value="<%= (esEdicion != null && esEdicion) ? marca.getMarca() : "" %>" 
                           placeholder="Ingrese el nombre de la marca" required>
                </div>
                
                <div style="display: flex; gap: 15px; justify-content: center;">
                    <button type="submit" class="btn btn-success">
                        <i class="fas fa-save me-2"></i>
                        <%= (esEdicion != null && esEdicion) ? "Actualizar" : "Guardar" %>
                    </button>
                    <a href="sr_marca" class="btn btn-secondary">
                        <i class="fas fa-times me-2"></i>Cancelar
                    </a>
                </div>
            </form>
        </div>
        <% } %>

        <% if (mostrarTabla != null && mostrarTabla && listaMarcas != null) { %>
        <!-- Tabla de Marcas -->
        <div class="table-container">
            <h3 class="table-title">Lista de Marcas</h3>
            <table class="data-table">
                <thead>
                    <tr>
                        <th class="id-column">ID</th>
                        <th>Marca</th>
                        <th class="actions-column">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Marca m : listaMarcas) { %>
                    <tr>
                        <td class="id-column"><%= m.getIdmarca() %></td>
                        <td><%= m.getMarca() %></td>
                        <td>
                            <div class="action-buttons">
                                <a href="sr_marca?action=actualizar&id=<%= m.getIdmarca() %>" class="btn btn-warning">
                                    <i class="fas fa-edit me-1"></i>Editar
                                </a>
                                <a href="sr_marca?action=eliminar&id=<%= m.getIdmarca() %>" 
                                   class="btn btn-danger" 
                                   onclick="return confirm('¿Está seguro de eliminar esta marca?')">
                                    <i class="fas fa-trash me-1"></i>Eliminar
                                </a>
                            </div>
                        </td>   
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"></script>
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