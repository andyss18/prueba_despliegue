<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="modelo.Producto"%>
<%@page import="modelo.Marca"%>
<%
    List<Producto> listaProductos = (List<Producto>) request.getAttribute("listaProductos");
    List<Marca> marcas = (List<Marca>) request.getAttribute("marcas");
    Producto producto = (Producto) request.getAttribute("producto");
    Boolean mostrarTabla = (Boolean) request.getAttribute("mostrarTabla");
    Boolean mostrarFormulario = (Boolean) request.getAttribute("mostrarFormulario");
    Boolean esEdicion = (Boolean) request.getAttribute("esEdicion");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Gestión de Productos - Sistema Empresarial</title>
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
            max-width: 1400px;
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

        .button-group {
            display: flex;
            gap: 15px;
            margin-bottom: 30px;
            flex-wrap: wrap;
            justify-content: center;
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

        .btn-info { 
            background: rgba(100, 200, 255, 0.2); 
            color: white; 
            border: 1px solid rgba(100, 200, 255, 0.3);
        }
        .btn-success { 
            background: rgba(100, 255, 150, 0.2); 
            color: white; 
            border: 1px solid rgba(100, 255, 150, 0.3);
        }
        .btn-secondary { 
            background: rgba(200, 200, 200, 0.2); 
            color: white; 
            border: 1px solid rgba(200, 200, 200, 0.3);
        }
        .btn-warning { 
            background: rgba(255, 200, 100, 0.2); 
            color: white; 
            border: 1px solid rgba(255, 200, 100, 0.3);
        }
        .btn-danger { 
            background: rgba(255, 100, 100, 0.2); 
            color: white; 
            border: 1px solid rgba(255, 100, 100, 0.3);
        }

        .error-message {
            background: rgba(255, 100, 100, 0.2);
            color: #ffcccc;
            padding: 18px 25px;
            border-radius: 15px;
            margin: 25px 0;
            text-align: center;
            font-weight: 600;
            border: 1px solid rgba(255, 100, 100, 0.3);
            backdrop-filter: blur(10px);
            animation: shake 0.5s ease-in-out;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }

        /* Estilos para el formulario */
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
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
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

        .form-input, .form-select, .form-textarea {
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

        .form-input::placeholder, .form-textarea::placeholder {
            color: rgba(255, 255, 255, 0.6);
        }

        .form-input:focus, .form-select:focus, .form-textarea:focus {
            outline: none;
            background: rgba(255, 255, 255, 0.15);
            border-color: rgba(255, 255, 255, 0.4);
            box-shadow: 0 0 0 3px rgba(255, 255, 255, 0.1);
        }

        .form-textarea {
            resize: vertical;
            min-height: 100px;
        }

        /* Estilos para imágenes */
        .img-thumbnail { 
            max-width: 70px; 
            max-height: 70px; 
            cursor: pointer;
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 8px;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.1);
        }

        .img-thumbnail:hover {
            transform: scale(1.1);
            border-color: rgba(100, 200, 255, 0.6);
            box-shadow: 0 4px 15px rgba(0,0,0,0.3);
        }

        .preview-image {
            max-width: 120px;
            max-height: 120px;
            margin-top: 12px;
            border: 2px solid rgba(100, 200, 255, 0.5);
            border-radius: 8px;
            display: none;
            background: rgba(255, 255, 255, 0.1);
        }

        .current-image {
            margin-top: 15px;
            padding: 12px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 8px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .current-image strong {
            color: white;
            display: block;
            margin-bottom: 8px;
        }

        .current-image small {
            color: rgba(255, 255, 255, 0.7);
            font-size: 0.85em;
        }

        /* Estilos para la tabla */
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
        }

        .table tr:hover {
            background: rgba(255, 255, 255, 0.05);
        }

        .action-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .btn-small {
            padding: 8px 12px;
            font-size: 0.85em;
            border-radius: 8px;
        }

        /* Modal para imágenes */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            padding-top: 60px;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.9);
            backdrop-filter: blur(10px);
        }

        .modal-content {
            margin: auto;
            display: block;
            max-width: 80%;
            max-height: 80%;
            border-radius: 10px;
            box-shadow: 0 10px 50px rgba(0,0,0,0.5);
        }

        .close {
            position: absolute;
            top: 20px;
            right: 35px;
            color: #f1f1f1;
            font-size: 40px;
            font-weight: bold;
            cursor: pointer;
            text-shadow: 0 2px 10px rgba(0,0,0,0.5);
            transition: color 0.3s ease;
        }

        .close:hover {
            color: #ff6b6b;
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
                align-items: center;
            }
            
            .btn {
                width: 100%;
                justify-content: center;
            }
            
            .table-container {
                padding: 15px;
            }
            
            .action-buttons {
                flex-direction: column;
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
    <div class="glass-container">
        <div class="page-header">
            <h1 class="page-title">📦 Gestión de Productos</h1>
            <p class="page-subtitle">Administra el inventario de productos del sistema</p>
        </div>

        <div class="button-group">
            <a href="${pageContext.request.contextPath}/sr_producto?action=mostrar" class="btn btn-info">📋 Mostrar Productos</a>
            <a href="${pageContext.request.contextPath}/sr_producto?action=agregar" class="btn btn-success">➕ Agregar Producto</a>
            <a href="${pageContext.request.contextPath}/ADMIN/marcas.jsp" class="btn btn-secondary">🏷️ Ir a Marcas</a>
        </div>

        <% if (error != null && !error.isEmpty()) { %>
            <div class="error-message"><%= error %></div>
        <% } %>

        <% if (mostrarFormulario != null && mostrarFormulario) { %>
        <!-- Formulario de Producto -->
        <div class="form-container">
            <h2 class="form-title"><%= esEdicion != null && esEdicion ? "✏️ Actualizar Producto" : "➕ Agregar Producto" %></h2>
            <form action="sr_producto" method="post" enctype="multipart/form-data" id="productoForm">
                <% if (esEdicion != null && esEdicion) { %>
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="<%= producto.getIdProducto() %>">
                <% } else { %>
                    <input type="hidden" name="action" value="insert">
                <% } %>
                
                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label" for="producto">Producto *</label>
                        <input type="text" id="producto" name="producto" class="form-input"
                               value="<%= (esEdicion != null && esEdicion) ? producto.getProducto() : "" %>" 
                               placeholder="Nombre del producto" required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label" for="idMarca">Marca *</label>
                        <select id="idMarca" name="idMarca" class="form-select" required>
                            <option value="">Seleccionar Marca</option>
                            <% for (Marca marca : marcas) { %>
                                <option value="<%= marca.getIdmarca() %>" 
                                    <%= (esEdicion != null && esEdicion && producto.getIdMarca() == marca.getIdmarca()) ? "selected" : "" %>>
                                    <%= marca.getMarca() %>
                                </option>
                            <% } %>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="descripcion">Descripción</label>
                    <textarea id="descripcion" name="descripcion" class="form-textarea" rows="3" 
                              placeholder="Descripción del producto"><%= (esEdicion != null && esEdicion) ? producto.getDescripcion() : "" %></textarea>
                </div>
                
                <div class="form-group">
                    <label class="form-label" for="imagen">Imagen</label>
                    <input type="file" id="imagen" name="imagen" class="form-input" accept="image/*" onchange="previewImage(this)">
                    
                    <!-- Previsualización de imagen nueva -->
                    <img id="imagePreview" class="preview-image" alt="Vista previa">
                    
                    <!-- Imagen actual (solo en edición) -->
                    <% if (esEdicion != null && esEdicion && producto.getImagen() != null && !producto.getImagen().isEmpty()) { %>
                        <div class="current-image">
                            <strong>Imagen actual:</strong>
                            <img src="<%= producto.getImagen() %>" class="img-thumbnail" alt="Imagen actual" 
                                 onclick="openModal('<%= producto.getImagen() %>')">
                            <br><small>Haz clic para ver en tamaño completo</small>
                        </div>
                    <% } %>
                </div>
                
                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label" for="precio_costo">Precio Costo *</label>
                        <input type="number" id="precio_costo" name="precio_costo" class="form-input" 
                               step="0.01" min="0" placeholder="0.00"
                               value="<%= (esEdicion != null && esEdicion) ? producto.getPrecioCosto() : "" %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label" for="precio_venta">Precio Venta *</label>
                        <input type="number" id="precio_venta" name="precio_venta" class="form-input" 
                               step="0.01" min="0" placeholder="0.00"
                               value="<%= (esEdicion != null && esEdicion) ? producto.getPrecioVenta() : "" %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label" for="existencia">Existencia *</label>
                        <input type="number" id="existencia" name="existencia" class="form-input" 
                               min="0" placeholder="0"
                               value="<%= (esEdicion != null && esEdicion) ? producto.getExistencia() : "" %>" required>
                    </div>
                </div>
                
                <div class="button-group" style="justify-content: flex-start; margin-top: 25px;">
                    <button type="submit" class="btn btn-success">
                        <%= (esEdicion != null && esEdicion) ? "💾 Actualizar Producto" : "💾 Guardar Producto" %>
                    </button>
                    <a href="sr_producto" class="btn btn-secondary">❌ Cancelar</a>
                </div>
            </form>
        </div>
        <% } %>

        <% if (mostrarTabla != null && mostrarTabla && listaProductos != null) { %>
        <!-- Tabla de Productos -->
        <div class="table-container">
            <h2 style="color: white; margin-bottom: 20px; text-shadow: 0 2px 8px rgba(0,0,0,0.3);">📋 Lista de Productos</h2>
            <table class="table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Producto</th>
                        <th>Marca</th>
                        <th>Descripción</th>
                        <th>Imagen</th>
                        <th>Precio Costo</th>
                        <th>Precio Venta</th>
                        <th>Existencia</th>
                        <th>Fecha Ingreso</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Producto p : listaProductos) { %>
                    <tr>
                        <td><%= p.getIdProducto() %></td>
                        <td><strong><%= p.getProducto() %></strong></td>
                        <td><%= p.getNombreMarca() %></td>
                        <td><%= p.getDescripcion() != null ? p.getDescripcion() : "" %></td>
                        <td>
                            <% if (p.getImagen() != null && !p.getImagen().isEmpty()) { %>
                                <img src="<%= p.getImagen() %>" class="img-thumbnail" alt="Imagen producto" 
                                     onclick="openModal('<%= p.getImagen() %>')">
                            <% } else { %>
                                <span style="color: rgba(255, 255, 255, 0.6);">Sin imagen</span>
                            <% } %>
                        </td>
                        <td>Q<%= p.getPrecioCosto() %></td>
                        <td><strong>Q<%= p.getPrecioVenta() %></strong></td>
                        <td><%= p.getExistencia() %></td>
                        <td><%= p.getFechaIngreso() %></td>
                        <td>
                            <div class="action-buttons">
                                <a href="sr_producto?action=actualizar&id=<%= p.getIdProducto() %>" 
                                   class="btn btn-warning btn-small">✏️ Editar</a>
                                <a href="sr_producto?action=eliminar&id=<%= p.getIdProducto() %>" 
                                   class="btn btn-danger btn-small" 
                                   onclick="return confirm('¿Está seguro de eliminar este producto?')">🗑️ Eliminar</a>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>

    <!-- Modal para ver imagen en tamaño completo -->
    <div id="imageModal" class="modal">
        <span class="close" onclick="closeModal()">&times;</span>
        <img class="modal-content" id="modalImage">
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
        // Función para previsualizar imagen antes de subir
        function previewImage(input) {
            var preview = document.getElementById('imagePreview');
            
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                }
                
                reader.readAsDataURL(input.files[0]);
            } else {
                preview.style.display = 'none';
            }
        }
        
        // Función para abrir el modal con la imagen
        function openModal(imageSrc) {
            document.getElementById('modalImage').src = imageSrc;
            document.getElementById('imageModal').style.display = "block";
        }
        
        // Función para cerrar el modal
        function closeModal() {
            document.getElementById('imageModal').style.display = "none";
        }
        
        // Cerrar modal al hacer clic fuera de la imagen
        window.onclick = function(event) {
            var modal = document.getElementById('imageModal');
            if (event.target == modal) {
                closeModal();
            }
        }
        
        // Cerrar modal con tecla ESC
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                closeModal();
            }
        });
    </script>
</body>
</html>