<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Venta,modelo.Cliente,modelo.Empleado,modelo.Producto" %>
<%@page import="java.util.*" %>
<%@page import="javax.swing.table.DefaultTableModel" %>
<%@page import="modelo.Usuario"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestión de Ventas - Sistema Empresarial</title>
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
            grid-template-columns: 1fr 1fr 1fr 2fr;
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

        .detail-section {
            margin-top: 30px;
        }

        .detail-title {
            color: white;
            font-size: 1.3em;
            font-weight: 600;
            margin-bottom: 20px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.4);
        }

        .table-container {
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(25px);
            border-radius: 18px;
            padding: 25px;
            border: 1px solid rgba(255, 255, 255, 0.15);
            margin-bottom: 20px;
        }

        .detail-table {
            width: 100%;
            border-collapse: collapse;
            color: white;
        }

        .detail-table th {
            background: rgba(255, 255, 255, 0.15);
            padding: 15px;
            text-align: left;
            font-weight: 600;
            border-bottom: 2px solid rgba(255, 255, 255, 0.2);
        }

        .detail-table td {
            padding: 12px 15px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .table-input {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            padding: 8px 12px;
            color: white;
            width: 100%;
        }

        .table-input:focus {
            outline: none;
            background: rgba(255, 255, 255, 0.15);
            border-color: rgba(255, 255, 255, 0.4);
        }

        .text-end {
            text-align: right;
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

        .btn-primary {
            background: rgba(74, 144, 226, 0.8);
            color: white;
        }

        .btn-outline {
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .btn-danger {
            background: rgba(220, 53, 69, 0.8);
            color: white;
            padding: 6px 12px;
            font-size: 0.9em;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.3);
        }

        .total-section {
            background: rgba(255, 255, 255, 0.1);
            padding: 15px 25px;
            border-radius: 12px;
            margin-top: 20px;
            text-align: right;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .total-text {
            color: white;
            font-size: 1.2em;
            font-weight: 700;
            text-shadow: 0 2px 4px rgba(0,0,0,0.4);
        }

        .history-section {
            margin-top: 40px;
        }

        .history-title {
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
        }
    </style>
</head>
<body>
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
        <div class="nav-menu">
            <a href="puestos.jsp" class="nav-link">Puestos</a>
            <a href="empleados.jsp" class="nav-link">Empleados</a>
            <a href="clientes.jsp" class="nav-link">Clientes</a>
            <a href="proveedores.jsp" class="nav-link">Proveedores</a>
            <a href="marcas.jsp" class="nav-link">Marcas</a>
            <a href="productos.jsp" class="nav-link">Productos</a>
            <a href="ventas.jsp" class="nav-link active">Ventas</a>
        </div>
    </div>

    <div class="glass-container">
        <h1 class="section-title">Gestión de Ventas</h1>
        
        <form action="sr_venta" method="post" id="frmVenta">
            <div class="form-grid">
                <div class="form-group">
                    <label class="form-label">No. Factura</label>
                    <input type="number" class="form-input" name="txt_nofactura" placeholder="Número de factura" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Serie</label>
                    <input type="text" class="form-input" name="txt_serie" maxlength="1" value="A" placeholder="Serie">
                </div>
                
                <div class="form-group">
                    <label class="form-label">Fecha</label>
                    <input type="date" class="form-input" name="txt_fecha" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Cliente</label>
                    <select class="form-select" name="drop_cliente" required>
                        <%
                            modelo.Cliente c = new modelo.Cliente();
                            DefaultTableModel tablaClientes = c.leer();
                            for (int i = 0; i < tablaClientes.getRowCount(); i++) {
                                String id = tablaClientes.getValueAt(i, 0).toString();
                                String nombre = tablaClientes.getValueAt(i, 1).toString() + " " + tablaClientes.getValueAt(i, 2).toString();
                                out.println("<option value='"+id+"'>"+nombre+"</option>");
                            }
                        %>
                    </select>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Empleado</label>
                    <select class="form-select" name="drop_empleado" required>
                        <%
                            modelo.Empleado e = new modelo.Empleado();
                            DefaultTableModel tablaEmpleados = e.leer();
                            for (int i = 0; i < tablaEmpleados.getRowCount(); i++) {
                                String id = tablaEmpleados.getValueAt(i, 0).toString();
                                String nombre = tablaEmpleados.getValueAt(i, 1).toString() + " " + tablaEmpleados.getValueAt(i, 2).toString();
                                out.println("<option value='"+id+"'>"+nombre+"</option>");
                            }
                        %>
                    </select>
                </div>
            </div>

            <!-- Sección Detalle -->
            <div class="detail-section">
                <h3 class="detail-title">Detalle de Venta</h3>
                
                <div class="table-container">
                    <table class="detail-table" id="tbl_det">
                        <thead>
                            <tr>
                                <th style="width:35%">Producto</th>
                                <th class="text-end" style="width:10%">Exist.</th>
                                <th class="text-end" style="width:15%">Precio</th>
                                <th class="text-end" style="width:15%">Cantidad</th>
                                <th class="text-end" style="width:15%">Subtotal</th>
                                <th style="width:10%"></th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>

                <button type="button" class="btn btn-outline" id="btn_add_row">
                    <i class="fas fa-plus me-2"></i>Agregar Producto
                </button>

                <div class="total-section">
                    <span class="total-text">Total: Q </span>
                    <span class="total-text" id="lbl_total">0.00</span>
                </div>

                <div style="text-align: center; margin-top: 30px;">
                    <button class="btn btn-primary" name="btn_crear" value="crear">
                        <i class="fas fa-save me-2"></i>Guardar Venta
                    </button>
                </div>
            </div>
        </form>
    </div>

    <!-- Historial de Ventas -->
    <div class="glass-container history-section">
        <h3 class="history-title">Ventas Recientes</h3>
        <div class="table-container">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>NoFactura</th>
                        <th>Serie</th>
                        <th>Fecha</th>
                        <th>Cliente</th>
                        <th>Empleado</th>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Venta v = new Venta();
                        DefaultTableModel tt = v.leer();
                        for (int i=0; i<tt.getRowCount(); i++){
                            out.println("<tr>");
                            for (int j=0; j<tt.getColumnCount(); j++){
                                out.println("<td>"+ tt.getValueAt(i,j) +"</td>");
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
        // Catálogo de productos
        let catalogo = [];

        // Cargar productos desde el servlet
        function cargarProductos() {
            return $.ajax({
                url: 'sr_producto?action=obtenerParaCompra',
                type: 'GET',
                dataType: 'json'
            });
        }

        // Inicializar la página
        $(document).ready(function() {
            cargarProductos().done(function(data) {
                catalogo = data;
                console.log('Productos cargados:', catalogo);
                
                if (catalogo.length === 0) {
                    catalogo = [{id:1, nom:"CEREAL", costo:30.00, exist:34}];
                }
                
                $("#btn_add_row").trigger("click");
            }).fail(function() {
                catalogo = [{id:1, nom:"CEREAL", costo:30.00, exist:34}];
                $("#btn_add_row").trigger("click");
            });
        });

        const fmt = function(n){ return (Number(n)||0).toFixed(2); };

        function optionHtml(o){
            // Para VENTAS usa un 25% más que el costo
            var precioVenta = o.costo * 1.25;
            return '<option value="'+o.id+'" data-precio="'+precioVenta+'" data-exist="'+o.exist+'">'
                   + o.nom + '</option>';
        }

        function filaDetalle(){
            var opts = '';
            for (var i=0; i<catalogo.length; i++){
                opts += optionHtml(catalogo[i]);
            }

            var html = ''
              + '<tr>'
              +   '<td>'
              +     '<select class="form-select sel-prod">'+ opts +'</select>'
              +     '<input type="hidden" name="detail_idProducto" class="idProd">'
              +   '</td>'
              +   '<td class="text-end exist"></td>'
              +   '<td class="text-end">'
              +     '<input type="number" step="0.01" min="0" class="table-input text-end precio" '
              +            'name="detail_precio" value="">'
              +   '</td>'
              +   '<td class="text-end">'
              +     '<input type="number" min="1" class="table-input text-end cant" '
              +            'name="detail_cantidad" value="1">'
              +   '</td>'
              +   '<td class="text-end sub">0.00</td>'
              +   '<td><button type="button" class="btn btn-danger btn-del"><i class="fas fa-times"></i></button></td>'
              + '</tr>';
            return html;
        }

        function recalc(){
            var total = 0;
            $("#tbl_det tbody tr").each(function(){
              var precio = parseFloat($(this).find(".precio").val())||0;
              var cant   = parseInt($(this).find(".cant").val())||0;
              var sub    = precio * cant;
              $(this).find(".sub").text(fmt(sub));
              total += sub;
            });
            $("#lbl_total").text(fmt(total));
        }

        $("#btn_add_row").on("click", function(){
            $("#tbl_det tbody").append( filaDetalle() );
            var $tr  = $("#tbl_det tbody tr").last();
            var $sel = $tr.find(".sel-prod");
            var opt  = $sel.find("option").first();
            $sel.val(opt.val());
            $tr.find(".idProd").val(opt.val());
            $tr.find(".precio").val(opt.data("precio"));
            $tr.find(".exist").text(opt.data("exist"));
            recalc();
        });

        $("#tbl_det tbody")
            .on("change", ".sel-prod", function(){
              var opt = $(this).find(":selected");
              var $tr = $(this).closest("tr");
              $tr.find(".idProd").val(opt.val());
              $tr.find(".precio").val(opt.data("precio"));
              $tr.find(".exist").text(opt.data("exist"));
              recalc();
            })
            .on("input", ".precio, .cant", function(){ recalc(); })
            .on("click", ".btn-del", function(){
              $(this).closest("tr").remove();
              recalc();
            });
    </script>
</body>
</html>