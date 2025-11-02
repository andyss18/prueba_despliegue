<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="modelo.Conexion" %>
<%@page import="modelo.Usuario"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestión de Clientes - Sistema Empresarial</title>
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

        /* Efecto de partículas sutiles */
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

        .nav-buttons {
            display: flex;
            gap: 15px;
        }

        .nav-btn {
            background: rgba(255, 255, 255, 0.15);
            color: white;
            padding: 12px 25px;
            border-radius: 35px;
            text-decoration: none;
            font-weight: 600;
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .nav-btn:hover {
            background: rgba(255, 255, 255, 0.25);
            transform: translateY(-2px);
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

        .form-input, .form-select {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            padding: 12px 15px;
            color: white;
            font-size: 1em;
            backdrop-filter: blur(10px);
            transition: all 0.3s ease;
        }

        .form-input:focus, .form-select:focus {
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

        /* Estilo para mostrar que hay un ID seleccionado */
        .id-selected {
            background: rgba(74, 144, 226, 0.2) !important;
            border: 1px solid rgba(74, 144, 226, 0.5) !important;
        }

        .selection-info {
            color: #4a90e2;
            font-size: 0.9em;
            text-align: center;
            margin-top: 10px;
            font-weight: 600;
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .glass-container {
                padding: 25px;
            }
            
            .nav-buttons {
                flex-direction: column;
                gap: 10px;
            }
            
            .button-group {
                flex-direction: column;
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
        <a href="index.jsp" class="nav-brand">
            <i class="fas fa-store me-2"></i>Sistema Empresarial
        </a>
        <div class="nav-buttons">
            <a href="index.jsp" class="nav-btn">
                <i class="fas fa-arrow-left me-2"></i>Menú Principal
            </a>
            <a href="ventas.jsp" class="nav-btn">
                <i class="fas fa-shopping-cart me-2"></i>Ir a Ventas
            </a>
        </div>
    </div>

    <div class="glass-container">
        <h1 class="section-title">Gestión de Clientes</h1>
        
        <form action="sr_cliente" method="post">
            <!-- CAMPO ID OCULTO PERO FUNCIONAL -->
            <input type="hidden" id="txt_id" name="txt_id" value="0">
            
            <div class="form-grid">
                <div class="form-group">
                    <label class="form-label">Nombres</label>
                    <input type="text" class="form-input" id="txt_nombres" name="txt_nombres" placeholder="Ingrese los nombres" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Apellidos</label>
                    <input type="text" class="form-input" id="txt_apellidos" name="txt_apellidos" placeholder="Ingrese los apellidos" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">NIT</label>
                    <input type="text" class="form-input" id="txt_nit" name="txt_nit" placeholder="Ingrese el NIT" pattern="[0-9]+" title="Solo números" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Teléfono</label>
                    <input type="text" class="form-input" id="txt_telefono" name="txt_telefono" placeholder="Ingrese el teléfono" pattern="[0-9-]+">
                </div>
                
                <div class="form-group">
                    <label class="form-label">Correo Electrónico</label>
                    <input type="email" class="form-input" id="txt_correo" name="txt_correo" placeholder="Ingrese el correo electrónico">
                </div>
                
                <div class="form-group">
                    <label class="form-label">Género</label>
                    <select class="form-select" id="drop_genero" name="drop_genero">
                        <option value="1">Masculino</option>
                        <option value="0">Femenino</option>
                    </select>
                </div>
            </div>
            
            <!-- Información de selección -->
            <div id="selectionInfo" class="selection-info" style="display: none;">
                <i class="fas fa-info-circle me-2"></i>Cliente seleccionado: <span id="selectedClientInfo"></span>
            </div>
            
            <div class="button-group">
                <button class="btn btn-primary" name="btn_crear" value="crear">
                    <i class="fas fa-plus me-2"></i>Crear Cliente
                </button>
                <button class="btn btn-success" name="btn_actualizar" value="actualizar">
                    <i class="fas fa-edit me-2"></i>Actualizar
                </button>
                <button class="btn btn-danger" name="btn_borrar" value="borrar" id="btnBorrar">
                    <i class="fas fa-trash me-2"></i>Borrar
                </button>
            </div>
        </form>
    </div>

    <div class="glass-container">
        <div class="table-container">
            <h3 class="table-title">Lista de Clientes</h3>
            <table class="data-table" id="tbl_clientes">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nombres</th>
                        <th>Apellidos</th>
                        <th>NIT</th>
                        <th>Género</th>
                        <th>Teléfono</th>
                        <th>Correo</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        modelo.Conexion conexion = new modelo.Conexion();
                        java.sql.PreparedStatement pstmt = null;
                        java.sql.ResultSet rs = null;
                        
                        try {
                            conexion.abrir_conexion();
                            String sql = "SELECT * FROM Clientes";
                            pstmt = conexion.conexionBD.prepareStatement(sql);
                            rs = pstmt.executeQuery();
                            
                            while (rs.next()) {
                                int id = rs.getInt("idCliente");
                                String nombres = rs.getString("nombres");
                                String apellidos = rs.getString("apellidos");
                                String nit = rs.getString("NIT");
                                int genero = rs.getInt("genero");
                                String telefono = rs.getString("telefono");
                                String correo = rs.getString("correo_electronico");
                    %>
                    <tr>
                        <td><%= id %></td>
                        <td><%= nombres %></td>
                        <td><%= apellidos %></td>
                        <td><%= nit %></td>
                        <td><%= genero == 1 ? "M" : "F" %></td>
                        <td><%= telefono != null ? telefono : "" %></td>
                        <td><%= correo != null ? correo : "" %></td>
                    </tr>
                    <% 
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='7' style='color: #ff6b6b; padding: 20px; text-align: center;'>Error: " + e.getMessage() + "</td></tr>");
                        } finally {
                            try {
                                if (rs != null) rs.close();
                                if (pstmt != null) pstmt.close();
                                conexion.cerrar_conexion();
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
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
        let selectedRow = null;

        $("#tbl_clientes").on("click", "tr", function(){
            const tds = $(this).find("td");
            if (tds.length > 0) {
                // Remover selección anterior
                if (selectedRow) {
                    selectedRow.removeClass('id-selected');
                }
                
                // Agregar selección actual
                $(this).addClass('id-selected');
                selectedRow = $(this);
                
                // Llenar formulario
                const id = tds.eq(0).text();
                const nombres = tds.eq(1).text();
                const apellidos = tds.eq(2).text();
                
                $("#txt_id").val(id); 
                $("#txt_nombres").val(nombres);
                $("#txt_apellidos").val(apellidos);
                $("#txt_nit").val(tds.eq(3).text());
                
                // Género
                const genero = tds.eq(4).text().trim();
                $("#drop_genero").val(genero === "M" ? "1" : "0");
                
                $("#txt_telefono").val(tds.eq(5).text());
                $("#txt_correo").val(tds.eq(6).text());
                
                // Mostrar información de selección
                $("#selectedClientInfo").text(`ID: ${id} - ${nombres} ${apellidos}`);
                $("#selectionInfo").show();
                
                // Habilitar botón de borrar
                $("#btnBorrar").prop('disabled', false);
            }
        });

        // Deshabilitar borrar si no hay selección
        $(document).ready(function() {
            $("#btnBorrar").prop('disabled', true);
        });

        // Confirmación para borrar
        $("form").on("submit", function(e) {
            const btnBorrar = document.querySelector("button[name='btn_borrar']");
            if (btnBorrar && e.originalEvent && e.originalEvent.submitter === btnBorrar) {
                const id = $("#txt_id").val();
                if (id === "0") {
                    e.preventDefault();
                    alert("Por favor, seleccione un cliente de la tabla para borrar.");
                    return false;
                }
                if (!confirm(`¿Está seguro de que desea eliminar al cliente con ID: ${id}?`)) {
                    e.preventDefault();
                    return false;
                }
            }
        });
    </script>
</body>
</html>