<%-- 
    Document   : protected
    Created on : 21/10/2025, 11:59:00 p. m.
    Author     : itsan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Protected Page</title>
</head>
<body>
    <h2>Página Protegida</h2>
    <button id="btnProtected">Ver mensaje protegido</button>
    <pre id="output"></pre>

    <script>
        document.getElementById("btnProtected").addEventListener("click", async () => {
            const token = localStorage.getItem("jwt"); // Tomamos el JWT guardado
            if (!token) {
                alert("No hay token. Primero haz login.");
                return;
            }

            try {
                const response = await fetch("protected", {
                    method: "GET",
                    headers: {
                        "Authorization": "Bearer " + token
                    }
                });

                if (!response.ok) {
                    document.getElementById("output").textContent = "Error: " + response.status + " " + response.statusText;
                    return;
                }

                const data = await response.json();
                document.getElementById("output").textContent = JSON.stringify(data, null, 2);
            } catch (err) {
                document.getElementById("output").textContent = "Error: " + err.message;
            }
        });
    </script>
</body>
</html>