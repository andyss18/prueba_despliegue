<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Empleado" %>
<%@page import="modelo.Puesto" %>
<%@page import="java.util.HashMap" %>
<%@page import="javax.swing.table.DefaultTableModel" %>
<%@page import="modelo.Usuario"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestión de Empleados - Sistema Empresarial</title>
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
            max-width: 1400px;
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
            max-width: 1400px;
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

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 30px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-label {
            color: white;
            font-weight: 600;
            margin-bottom: 8px;
            text-shadow: 0 1px 3px rgba(0,0,0,0.4);
        }

        .form-input {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            padding: 12px 15px;
            color: white;
            font-size: 1em;
            backdrop-filter: blur(10px);
            transition: all 0.3s ease;
        }

        .form-select {
            background: rgba(40, 40, 40, 0.95);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 12px;
            padding: 12px 15px;
            color: white;
            font-size: 1em;
            backdrop-filter: blur(10px);
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .form-select:focus {
            outline: none;
            background: rgba(50, 50, 50, 0.95);
            border-color: rgba(255, 255, 255, 0.5);
            box-shadow: 0 0 0 3px rgba(255,255,255,0.1);
        }

        .form-select option {
            background: rgba(50, 50, 50, 0.98);
            color: white;
            padding: 12px 15px;
            font-size: 1em;
            border: none;
        }

        .form-select option:hover {
            background: rgba(74, 144, 226, 0.9) !important;
            color: white !important;
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

        .button-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 20px;
        }

        .btn {
            padding: 12px 30px;
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

        .btn-primary {
            background: rgba(74, 144, 226, 0.8);
            color: white;
        }

        .btn-success {
            background: rgba(40, 167, 69, 0.8);
            color: white;
        }

        .btn-danger {
            background: rgba(220, 53, 69, 0.8);
            color: white;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.3);
        }

        .table-container {
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(25px);
            border-radius: 18px;
            padding: 25px;
            border: 1px solid rgba(255, 255, 255, 0.15);
            margin-top: 30px;
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
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .data-table tr:hover td {
            background: rgba(255, 255, 255, 0.1);
            transform: scale(1.01);
        }

        .id-column {
            width: 80px;
        }

        .action-column {
            width: 120px;
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            
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
    <%
        HttpSession sesion = request.getSession(false);
        if (sesion == null || sesion.getAttribute("usuario") == null) {
            response.sendRedirect("index.jsp");
            return;
        }
    %>

    <div class="top-nav">
        <a href="${pageContext.request.contextPath}/index.jsp" class="nav-brand">
            <i class="fas fa-store me-2"></i>Sistema Empresarial
        </a>

    </div>

    <div class="glass-container">
        <h1 class="section-title">Gestión de Empleados</h1>
        
        <form action="${pageContext.request.contextPath}/sr_empleado" method="post">
            <div class="form-grid">
                <div class="form-group">
                    <label class="form-label">ID</label>
                    <input type="text" class="form-input" id="txt_id" name="txt_id" value="0" readonly 
                           style="background: rgba(255,255,255,0.05);">
                </div>
                
                <div class="form-group">
                    <label class="form-label">Nombres</label>
                    <input type="text" class="form-input" id="txt_nombres" name="txt_nombres" 
                           placeholder="Ingrese los nombres" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Apellidos</label>
                    <input type="text" class="form-input" id="txt_apellidos" name="txt_apellidos" 
                           placeholder="Ingrese los apellidos" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Dirección</label>
                    <input type="text" class="form-input" id="txt_direccion" name="txt_direccion" 
                           placeholder="Ingrese la dirección">
                </div>
                
                <div class="form-group">
                    <label class="form-label">Teléfono</label>
                    <input type="text" class="form-input" id="txt_telefono" name="txt_telefono" 
                           placeholder="Ingrese el teléfono">
                </div>
                
                <div class="form-group">
                    <label class="form-label">DPI</label>
                    <input type="text" class="form-input" id="txt_dpi" name="txt_dpi" 
                           placeholder="Ingrese el DPI">
                </div>
                
                <div class="form-group">
                    <label class="form-label">Género</label>
                    <select class="form-select" id="drop_genero" name="drop_genero">
                        <option value="">(sin especificar)</option>
                        <option value="1">Masculino</option>
                        <option value="0">Femenino</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Fecha Nacimiento</label>
                    <input type="date" class="form-input" id="txt_fecha_nac" name="txt_fecha_nac">
                </div>
                
                <div class="form-group">
                    <label class="form-label">Puesto</label>
                    <select class="form-select" id="drop_puesto" name="drop_puesto" required>
                        <%
                            Puesto p = new Puesto();
                            HashMap<String,String> mapa = p.leerDrop();
                            for(String id: mapa.keySet()){
                                out.println("<option value='"+id+"'>"+mapa.get(id)+"</option>");
                            }
                        %>
                    </select>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Inicio Labores</label>
                    <input type="date" class="form-input" id="txt_fecha_inicio" name="txt_fecha_inicio">
                </div>
            </div>
            
            <div class="button-group">
                <button class="btn btn-primary" name="btn_crear" value="crear">
                    <i class="fas fa-plus me-2"></i>Crear Empleado
                </button>
                <button class="btn btn-success" name="btn_actualizar" value="actualizar">
                    <i class="fas fa-edit me-2"></i>Actualizar
                </button>
                <button class="btn btn-danger" name="btn_borrar" value="borrar">
                    <i class="fas fa-trash me-2"></i>Borrar
                </button>
            </div>
        </form>
        
        <div class="table-container">
            <h3 class="table-title">Lista de Empleados</h3>
            <table class="data-table" id="tbl_empleados">
                <thead>
                    <tr>
                        <th class="id-column">ID</th>
                        <th>Nombres</th>
                        <th>Apellidos</th>
                        <th>Dirección</th>
                        <th>Teléfono</th>
                        <th>DPI</th>
                        <th>Género</th>
                        <th>Fecha Nac.</th>
                        <th>Puesto</th>
                        <th class="id-column">idPuesto</th>
                        <th>Inicio</th>
                        <th>Ingreso</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Empleado e = new Empleado();
                        DefaultTableModel t = e.leer();
                        for (int i=0; i<t.getRowCount(); i++){
                            out.println("<tr>");
                            for (int c=0; c<t.getColumnCount(); c++){
                                out.println("<td>"+ t.getValueAt(i,c) +"</td>");
                            }
                            out.println("</tr>");
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
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
        // Al hacer click en una fila, llenar el formulario
        $("#tbl_empleados").on("click","tr", function(){
            const tds = $(this).find("td");
            $("#txt_id").val( tds.eq(0).text() );
            $("#txt_nombres").val( tds.eq(1).text() );
            $("#txt_apellidos").val( tds.eq(2).text() );
            $("#txt_direccion").val( tds.eq(3).text() );
            $("#txt_telefono").val( tds.eq(4).text() );
            $("#txt_dpi").val( tds.eq(5).text() );
            const generoTxt = tds.eq(6).text().trim();
            $("#drop_genero").val(
                generoTxt === "Masculino" ? "1" :
                generoTxt === "Femenino"  ? "0" : ""
            );
            $("#txt_fecha_nac").val( tds.eq(7).text() );
            $("#drop_puesto").val( tds.eq(9).text() );
            $("#txt_fecha_inicio").val( tds.eq(10).text() );
        });
    </script>
</body>
</html>