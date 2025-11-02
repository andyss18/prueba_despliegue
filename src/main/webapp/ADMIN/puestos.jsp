<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Puesto" %>
<%@page import="javax.swing.table.DefaultTableModel" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestión de Puestos - Sistema Empresarial</title>
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

        .glass-container {
            width: 95%;
            max-width: 1200px;
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(35px);
            border-radius: 25px;
            padding: 40px;
            margin-top: 20px;
            box-shadow: 
                0 25px 60px rgba(0,0,0,0.25),
                inset 0 1px 0 rgba(255,255,255,0.1);
            border: 1px solid rgba(255, 255, 255, 0.15);
            animation: appear 1s ease-out;
            position: relative;
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

        .page-header {
            text-align: center;
            margin-bottom: 35px;
        }

        .page-title {
            color: white;
            font-size: 2.5em;
            font-weight: 700;
            margin-bottom: 10px;
            text-shadow: 0 4px 12px rgba(0,0,0,0.4);
        }

        .page-subtitle {
            color: rgba(255, 255, 255, 0.8);
            font-size: 1.2em;
            font-weight: 400;
        }

        /* Formulario */
        .form-container {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(25px);
            border-radius: 20px;
            padding: 35px;
            margin: 25px 0;
            border: 1px solid rgba(255, 255, 255, 0.15);
            box-shadow: 
                inset 0 1px 0 rgba(255,255,255,0.1),
                0 15px 40px rgba(0,0,0,0.2);
        }

        .form-title {
            color: white;
            font-size: 1.8em;
            font-weight: 700;
            margin-bottom: 25px;
            text-shadow: 0 2px 8px rgba(0,0,0,0.3);
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-bottom: 25px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            color: white;
            margin-bottom: 10px;
            font-weight: 600;
            text-shadow: 0 2px 6px rgba(0,0,0,0.3);
        }

        .form-input {
            width: 100%;
            padding: 14px 18px;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            color: white;
            font-size: 1em;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }

        .form-input::placeholder {
            color: rgba(255, 255, 255, 0.6);
        }

        .form-input:focus {
            outline: none;
            background: rgba(255, 255, 255, 0.15);
            border-color: rgba(255, 255, 255, 0.4);
            box-shadow: 0 0 0 3px rgba(255, 255, 255, 0.1);
        }

        .form-input[readonly] {
            background: rgba(255, 255, 255, 0.05);
            color: rgba(255, 255, 255, 0.6);
            border-color: rgba(255, 255, 255, 0.1);
        }

        /* Botones */
        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 25px;
            flex-wrap: wrap;
        }

        .btn {
            padding: 14px 25px;
            border-radius: 15px;
            font-size: 1em;
            font-weight: 600;
            border: none;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.4s ease;
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(10px);
            box-shadow: 
                0 8px 25px rgba(0,0,0,0.25),
                inset 0 1px 0 rgba(255,255,255,0.1);
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
            transition: left 0.6s;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 
                0 12px 30px rgba(0,0,0,0.3),
                inset 0 1px 0 rgba(255,255,255,0.15);
        }

        .btn-primary { 
            background: rgba(100, 150, 255, 0.2); 
            color: white; 
            border: 1px solid rgba(100, 150, 255, 0.3);
        }
        .btn-success { 
            background: rgba(100, 255, 150, 0.2); 
            color: white; 
            border: 1px solid rgba(100, 255, 150, 0.3);
        }
        .btn-danger { 
            background: rgba(255, 100, 100, 0.2); 
            color: white; 
            border: 1px solid rgba(255, 100, 100, 0.3);
        }
        .btn-secondary { 
            background: rgba(200, 200, 200, 0.2); 
            color: white; 
            border: 1px solid rgba(200, 200, 200, 0.3);
        }

        /* Tabla */
        .table-container {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(25px);
            border-radius: 20px;
            padding: 25px;
            margin-top: 25px;
            border: 1px solid rgba(255, 255, 255, 0.15);
            overflow-x: auto;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            color: white;
        }

        .table th {
            background: rgba(255, 255, 255, 0.15);
            padding: 16px 12px;
            text-align: left;
            font-weight: 600;
            border-bottom: 2px solid rgba(255, 255, 255, 0.2);
        }

        .table td {
            padding: 14px 12px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;
        }

        .table tr {
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .table tr:hover {
            background: rgba(255, 255, 255, 0.08);
            transform: translateX(5px);
        }

        .table tr.selected {
            background: rgba(100, 150, 255, 0.15);
            border-left: 3px solid rgba(100, 150, 255, 0.5);
        }

        /* Línea divisoria */
        .divider {
            height: 2px;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            margin: 30px 0;
            border: none;
        }

        /* Navegación */
        .nav-container {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(25px);
            border-radius: 15px;
            padding: 15px 25px;
            margin-bottom: 25px;
            border: 1px solid rgba(255, 255, 255, 0.15);
        }

        .nav-links {
            display: flex;
            gap: 20px;
            align-items: center;
        }

        .nav-brand {
            color: white;
            font-size: 1.3em;
            font-weight: 700;
            text-decoration: none;
            text-shadow: 0 2px 8px rgba(0,0,0,0.3);
        }

        .nav-link {
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            font-weight: 500;
            padding: 8px 16px;
            border-radius: 10px;
            transition: all 0.3s ease;
        }

        .nav-link:hover, .nav-link.active {
            color: white;
            background: rgba(255, 255, 255, 0.15);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .glass-container {
                padding: 25px;
                width: 98%;
            }
            
            .page-title {
                font-size: 2em;
            }
            
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .button-group {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
                justify-content: center;
            }
            
            .table-container {
                padding: 15px;
            }
            
            .nav-links {
                flex-direction: column;
                gap: 10px;
            }
        }

        @media (max-width: 480px) {
            body {
                padding: 10px;
            }
            
            .glass-container {
                padding: 20px;
            }
            
            .form-container {
                padding: 20px;
            }
            
            .page-title {
                font-size: 1.7em;
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
    <div class="nav-container">
        <div class="nav-links">
            <a href="menu.jsp" class="nav-brand">🏢 Sistema Empresarial</a>
            <a href="${pageContext.request.contextPath}/ADMIN/puestos.jsp" class="nav-link active">💼 Puestos</a>
            <a href="${pageContext.request.contextPath}/ADMIN/empleados.jsp" class="nav-link">👨‍💼 Empleados</a>
        </div>
    </div>

    <div class="glass-container">
        <div class="page-header">
            <h1 class="page-title">💼 Gestión de Puestos</h1>
            <p class="page-subtitle">Administra los puestos de trabajo en el sistema</p>
        </div>

        <div class="form-container">
            <h2 class="form-title">📝 Formulario de Puestos</h2>
            <form action="sr_puesto" method="post" class="form-grid">
                <div class="form-group">
                    <label class="form-label" for="txt_id">ID del Puesto</label>
                    <input type="text" class="form-input" id="txt_id" name="txt_id" value="0" readonly>
                </div>
                
                <div class="form-group">
                    <label class="form-label" for="txt_puesto">Nombre del Puesto *</label>
                    <input type="text" class="form-input" id="txt_puesto" name="txt_puesto" 
                           placeholder="Ej: Cajero, Gerente, Vendedor..." required>
                </div>
            </form>

            <div class="button-group">
                <button class="btn btn-primary" name="btn_crear" value="crear" type="submit" form="puestoForm">
                    ➕ Crear Puesto
                </button>
                <button class="btn btn-success" name="btn_actualizar" value="actualizar" type="submit" form="puestoForm">
                    ✏️ Actualizar
                </button>
                <button class="btn btn-danger" name="btn_borrar" value="borrar" type="submit" form="puestoForm" 
                        onclick="return confirm('¿Está seguro de eliminar este puesto?')">
                    🗑️ Eliminar
                </button>
            </div>
        </div>

        <hr class="divider">

        <div class="table-container">
            <h2 style="color: white; margin-bottom: 20px; text-shadow: 0 2px 8px rgba(0,0,0,0.3);">
                📋 Lista de Puestos
            </h2>
            <table class="table" id="tbl_puestos">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Puesto</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Puesto p = new Puesto();
                        DefaultTableModel t = p.leer();
                        for (int i=0; i<t.getRowCount(); i++){
                            out.println("<tr data-id='"+t.getValueAt(i,0)+"'>");
                            out.println("<td>"+t.getValueAt(i,0)+"</td>");
                            out.println("<td><strong>"+t.getValueAt(i,1)+"</strong></td>");
                            out.println("</tr>");
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Formulario oculto para enviar los datos -->
    <form id="puestoForm" action="${pageContext.request.contextPath}/sr_puesto" method="post" style="display: none;">
        <input type="hidden" id="form_txt_id" name="txt_id" value="0">
        <input type="hidden" id="form_txt_puesto" name="txt_puesto">
        <input type="hidden" id="form_action" name="btn_action">
    </form>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
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
        // Manejar clic en filas de la tabla
        $("#tbl_puestos").on("click", "tr", function(){
            // Remover selección anterior
            $("#tbl_puestos tr").removeClass("selected");
            
            // Seleccionar fila actual
            $(this).addClass("selected");
            
            const id = $(this).data("id");
            const puesto = $(this).find("td").eq(1).text();
            
            $("#txt_id").val(id);
            $("#txt_puesto").val(puesto);
            
            // Actualizar formulario oculto
            $("#form_txt_id").val(id);
            $("#form_txt_puesto").val(puesto);
        });

        // Manejar botones de acción
        $(".btn").on("click", function(e){
            if ($(this).attr("type") === "submit") {
                const action = $(this).attr("name");
                const value = $(this).attr("value");
                
                // Validar que haya un puesto seleccionado para actualizar/eliminar
                if ((value === "actualizar" || value === "borrar") && $("#txt_id").val() === "0") {
                    e.preventDefault();
                    alert("Por favor, seleccione un puesto de la tabla para " + 
                         (value === "actualizar" ? "actualizar" : "eliminar"));
                    return;
                }
                
                // Validar que el campo puesto no esté vacío
                if ($("#txt_puesto").val().trim() === "") {
                    e.preventDefault();
                    alert("Por favor, ingrese el nombre del puesto");
                    return;
                }
                
                // Actualizar formulario oculto
                $("#form_txt_id").val($("#txt_id").val());
                $("#form_txt_puesto").val($("#txt_puesto").val());
                $("#form_action").attr("name", action);
                $("#form_action").attr("value", value);
            }
        });

        // Efecto de aparición para las filas de la tabla
        $(document).ready(function() {
            $("#tbl_puestos tbody tr").each(function(index) {
                $(this).delay(100 * index).animate({
                    opacity: 1
                }, 300);
            });
        });
    </script>
</body>
</html>