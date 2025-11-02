<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Proveedor" %>
<%@page import="javax.swing.table.DefaultTableModel" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Proveedores</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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

    .navbar {
        background: rgba(0, 0, 0, 0.7) !important;
        backdrop-filter: blur(15px);
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    }

    .navbar-brand, .nav-link {
        color: white !important;
        text-shadow: 0 2px 4px rgba(0,0,0,0.3);
    }

    .nav-link.active {
        background: rgba(255, 255, 255, 0.15);
        border-radius: 8px;
    }

    .glass-container {
        background: rgba(255, 255, 255, 0.08);
        backdrop-filter: blur(35px);
        border-radius: 25px;
        padding: 35px;
        margin-top: 30px;
        margin-bottom: 30px;
        box-shadow: 
            0 25px 60px rgba(0,0,0,0.25),
            inset 0 1px 0 rgba(255,255,255,0.1);
        border: 1px solid rgba(255, 255, 255, 0.15);
        animation: appear 1s ease-out;
        position: relative;
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

    .page-title {
        color: white;
        font-weight: 700;
        text-shadow: 0 4px 8px rgba(0,0,0,0.4);
        margin-bottom: 25px;
        font-size: 2.2rem;
    }

    .glass-card {
        background: rgba(255, 255, 255, 0.1);
        backdrop-filter: blur(20px);
        border-radius: 18px;
        border: 1px solid rgba(255, 255, 255, 0.15);
        box-shadow: 
            0 12px 30px rgba(0,0,0,0.2),
            inset 0 1px 0 rgba(255,255,255,0.1);
        overflow: hidden;
    }

    .glass-card .card-header {
        background: rgba(255, 255, 255, 0.15);
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        color: white;
        font-weight: 600;
        padding: 18px 25px;
    }

    .form-label {
        color: white;
        font-weight: 600;
        margin-bottom: 8px;
        text-shadow: 0 2px 4px rgba(0,0,0,0.3);
    }

    .form-control {
        background: rgba(255, 255, 255, 0.1);
        border: 1px solid rgba(255, 255, 255, 0.2);
        border-radius: 12px;
        color: white;
        padding: 12px 15px;
        transition: all 0.3s ease;
    }

    .form-control:focus {
        background: rgba(255, 255, 255, 0.15);
        border-color: rgba(255, 255, 255, 0.4);
        box-shadow: 0 0 0 0.25rem rgba(255, 255, 255, 0.15);
        color: white;
    }

    .form-control::placeholder {
        color: rgba(255, 255, 255, 0.6);
    }

    .btn {
        border-radius: 12px;
        padding: 12px 25px;
        font-weight: 600;
        transition: all 0.3s ease;
        border: none;
        position: relative;
        overflow: hidden;
    }

    .btn::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
        transition: left 0.5s;
    }

    .btn:hover::before {
        left: 100%;
    }

    .btn-primary {
        background: rgba(13, 110, 253, 0.7);
        color: white;
        box-shadow: 0 6px 15px rgba(13, 110, 253, 0.3);
    }

    .btn-primary:hover {
        background: rgba(13, 110, 253, 0.8);
        transform: translateY(-3px);
        box-shadow: 0 10px 20px rgba(13, 110, 253, 0.4);
    }

    .btn-success {
        background: rgba(25, 135, 84, 0.7);
        color: white;
        box-shadow: 0 6px 15px rgba(25, 135, 84, 0.3);
    }

    .btn-success:hover {
        background: rgba(25, 135, 84, 0.8);
        transform: translateY(-3px);
        box-shadow: 0 10px 20px rgba(25, 135, 84, 0.4);
    }

    .btn-danger {
        background: rgba(220, 53, 69, 0.7);
        color: white;
        box-shadow: 0 6px 15px rgba(220, 53, 69, 0.3);
    }

    .btn-danger:hover {
        background: rgba(220, 53, 69, 0.8);
        transform: translateY(-3px);
        box-shadow: 0 10px 20px rgba(220, 53, 69, 0.4);
    }

    .btn-outline-secondary {
        background: rgba(255, 255, 255, 0.1);
        border: 1px solid rgba(255, 255, 255, 0.3);
        color: white;
    }

    .btn-outline-secondary:hover {
        background: rgba(255, 255, 255, 0.2);
        border-color: rgba(255, 255, 255, 0.5);
        transform: translateY(-3px);
    }

    .table-responsive {
        border-radius: 18px;
        overflow: hidden;
        box-shadow: 0 12px 30px rgba(0,0,0,0.2);
    }

    .table {
        background: rgba(255, 255, 255, 0.1);
        backdrop-filter: blur(20px);
        color: white;
        margin-bottom: 0;
    }

    .table thead th {
        background: rgba(0, 0, 0, 0.4);
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        color: white;
        font-weight: 600;
        padding: 15px;
    }

    .table tbody tr {
        transition: all 0.3s ease;
        border-bottom: 1px solid rgba(255, 255, 255, 0.05);
    }

    .table tbody tr:hover {
        background: rgba(255, 255, 255, 0.15);
        cursor: pointer;
        transform: translateY(-2px);
    }

    .table tbody td {
        padding: 15px;
        border-color: rgba(255, 255, 255, 0.05);
    }

    hr {
        border-color: rgba(255, 255, 255, 0.2);
        margin: 30px 0;
    }

    @media (max-width: 768px) {
        .glass-container {
            padding: 25px;
            margin-top: 20px;
        }
        
        .page-title {
            font-size: 1.8rem;
        }
        
        .btn {
            width: 100%;
            margin-bottom: 10px;
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

<div class="container">
  <div class="glass-container">
    <h1 class="page-title">Gestión de Proveedores</h1>
    
    <div class="d-flex justify-content-between align-items-center mb-4">
      <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-outline-secondary">
          <i class="fas fa-arrow-left me-2"></i>Regresar al Menú
        </a>
        <a href="${pageContext.request.contextPath}/ADMIN/compras.jsp" class="btn btn-success">
          <i class="fas fa-boxes me-2"></i>Ir a Compras
        </a>
      </div>
    </div>

    <div class="glass-card mb-5">
      <div class="card-header">
        <i class="fas fa-user-plus me-2"></i>Formulario de Proveedores
      </div>
      <div class="card-body p-4">
        <form action="${pageContext.request.contextPath}/sr_proveedor" method="post" class="row g-4">
          <input type="hidden" id="txt_id" name="txt_id" value="0">

          <div class="col-md-6">
            <label class="form-label">Proveedor</label>
            <input type="text" class="form-control" id="txt_proveedor" name="txt_proveedor" placeholder="Ingrese el nombre del proveedor" required>
          </div>
          <div class="col-md-6">
            <label class="form-label">NIT</label>
            <input type="text" class="form-control" id="txt_nit" name="txt_nit" placeholder="Ingrese el NIT" required>
          </div>

          <div class="col-md-6">
            <label class="form-label">Dirección</label>
            <input type="text" class="form-control" id="txt_direccion" name="txt_direccion" placeholder="Ingrese la dirección">
          </div>
          <div class="col-md-6">
            <label class="form-label">Teléfono</label>
            <input type="text" class="form-control" id="txt_telefono" name="txt_telefono" placeholder="Ingrese el teléfono">
          </div>

          <div class="col-12 mt-3">
            <button class="btn btn-primary me-2" name="btn_crear" value="crear">
              <i class="fas fa-plus-circle me-2"></i>Crear
            </button>
            <button class="btn btn-success me-2" name="btn_actualizar" value="actualizar">
              <i class="fas fa-sync-alt me-2"></i>Actualizar
            </button>
            <button class="btn btn-danger" name="btn_borrar" value="borrar">
              <i class="fas fa-trash-alt me-2"></i>Borrar
            </button>
          </div>
        </form>
      </div>
    </div>

    <div class="glass-card">
      <div class="card-header">
        <i class="fas fa-list me-2"></i>Lista de Proveedores
      </div>
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table table-hover" id="tbl_proveedores">
            <thead>
              <tr>
                <th>ID</th>
                <th>Proveedor</th>
                <th>NIT</th>
                <th>Dirección</th>
                <th>Teléfono</th>
              </tr>
            </thead>
            <tbody>
              <%
                Proveedor p = new Proveedor();
                DefaultTableModel t = p.leer();
                for (int i=0; i<t.getRowCount(); i++){
                  out.println("<tr>");
                  for (int col=0; col<t.getColumnCount(); col++){
                    out.println("<td>"+ t.getValueAt(i,col) +"</td>");
                  }
                  out.println("</tr>");
                }
              %>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>

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
  // Selección de filas en la tabla
  $("#tbl_proveedores").on("click","tr", function(){
    const tds = $(this).find("td");
    $("#txt_id").val( tds.eq(0).text() );
    $("#txt_proveedor").val( tds.eq(1).text() );
    $("#txt_nit").val( tds.eq(2).text() );
    $("#txt_direccion").val( tds.eq(3).text() );
    $("#txt_telefono").val( tds.eq(4).text() );
  });
</script>
</body>
</html>