<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sistema de Gestión Empresarial - Login</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700;800&display=swap');
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            /* Misma imagen de fondo */
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

        /* Efecto de partículas sutiles en el fondo (mismo que el principal) */
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
            max-width: 450px;
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(35px);
            border-radius: 25px;
            padding: 50px 40px;
            box-shadow: 
                0 25px 60px rgba(0,0,0,0.25),
                inset 0 1px 0 rgba(255,255,255,0.1);
            border: 1px solid rgba(255, 255, 255, 0.15);
            animation: appear 1s ease-out;
            position: relative;
        }

        /* Efecto de borde luminoso sutil (mismo que el principal) */
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

        .login-header {
            text-align: center;
            margin-bottom: 35px;
        }

        .login-title {
            color: white;
            font-size: 2.2em;
            font-weight: 700;
            margin-bottom: 10px;
            text-shadow: 0 4px 12px rgba(0,0,0,0.4);
        }

        .login-subtitle {
            color: rgba(255, 255, 255, 0.8);
            font-size: 1.1em;
            font-weight: 400;
        }

        .form-group {
            margin-bottom: 25px;
            position: relative;
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
            padding: 16px 20px;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 15px;
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

        .login-btn {
            width: 100%;
            background: rgba(255, 255, 255, 0.15);
            color: white;
            padding: 18px;
            border-radius: 15px;
            font-size: 1.1em;
            font-weight: 700;
            border: 1px solid rgba(255, 255, 255, 0.2);
            cursor: pointer;
            text-align: center;
            position: relative;
            overflow: hidden;
            transition: all 0.4s ease;
            box-shadow: 
                0 12px 30px rgba(0,0,0,0.25),
                inset 0 1px 0 rgba(255,255,255,0.1);
            margin-top: 10px;
            font-family: 'Poppins', sans-serif;
        }

        .login-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
            transition: left 0.6s;
        }

        .login-btn:hover::before {
            left: 100%;
        }

        .login-btn:hover {
            transform: translateY(-3px);
            background: rgba(255, 255, 255, 0.22);
            box-shadow: 
                0 15px 35px rgba(0,0,0,0.3),
                inset 0 1px 0 rgba(255,255,255,0.15);
        }

        .login-btn:active {
            transform: translateY(-1px);
        }

        .error-message {
            background: rgba(255, 100, 100, 0.2);
            color: #ffcccc;
            padding: 15px 20px;
            border-radius: 12px;
            margin-top: 25px;
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

        .system-logo {
            text-align: center;
            margin-bottom: 10px;
        }

        .logo-icon {
            font-size: 3.5em;
            filter: drop-shadow(0 4px 12px rgba(0,0,0,0.4));
        }

        @media (max-width: 768px) {
            .glass-container {
                padding: 40px 30px;
                max-width: 400px;
            }
            
            .login-title {
                font-size: 2em;
            }
        }

        @media (max-width: 480px) {
            .glass-container {
                padding: 30px 25px;
                max-width: 350px;
            }
            
            .login-title {
                font-size: 1.8em;
            }
            
            .form-input {
                padding: 14px 18px;
            }
            
            .login-btn {
                padding: 16px;
            }
        }
    </style>
</head>
<body>
    <div class="glass-container">
        <div class="system-logo">
            <div class="logo-icon">🔐</div>
        </div>
        
        <div class="login-header">
            <h1 class="login-title">Sistema de Gestión</h1>
            <p class="login-subtitle">Ingrese sus credenciales</p>
        </div>

        <form action="login" method="post">
            <div class="form-group">
                <label class="form-label">Usuario:</label>
                <input type="text" name="username" class="form-input" placeholder="Ingrese su usuario" required>
            </div>
            
            <div class="form-group">
                <label class="form-label">Contraseña:</label>
                <input type="password" name="password" class="form-input" placeholder="Ingrese su contraseña" required>
            </div>
            
            <button type="submit" class="login-btn">Ingresar al Sistema</button>
        </form>

    <% 
        String error = request.getParameter("error");
        if (error != null) {
            switch (error) {
                case "true":
                    out.println("<p class='error'>Usuario o contraseña incorrectos.</p>");
                    break;
                case "notlogged":
                    out.println("<p class='error'>Debes iniciar sesión primero.</p>");
                    break;
                case "permiso":
                    out.println("<p class='error'>No tienes permiso para acceder a esa página.</p>");
                    break;
                default:
                    out.println("<p class='error'>Error desconocido.</p>");
            }
        }
    %>
    </div>
</body>
</html>