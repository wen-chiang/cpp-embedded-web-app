#include <crow.h>

#include <string>

int main()
{
    crow::SimpleApp app;

    CROW_ROUTE(app, "/")
    ([] {
        const std::string page = R"HTML(
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>C++ Embedded Web App</title>
    <style>
        body {
            font-family: system-ui, sans-serif;
            margin: 3rem;
            color: #17202a;
            background: #f5f7fa;
        }

        main {
            max-width: 40rem;
            padding: 2rem;
            border-radius: 0.75rem;
            background: white;
            box-shadow: 0 0.25rem 1rem #0002;
        }

        button {
            padding: 0.6rem 1rem;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <main>
        <h1>C++ Embedded Web App</h1>
        <p>The C++ executable is serving this interface.</p>
        <button id="load-message">Call C++ endpoint</button>
        <p id="result" aria-live="polite"></p>
    </main>

    <script>
        document.getElementById("load-message").addEventListener(
            "click",
            async () => {
                try {
                    const response = await fetch("/api/message");
                    if (!response.ok) {
                        throw new Error(`HTTP ${response.status}`);
                    }

                    const data = await response.json();
                    document.getElementById("result").textContent =
                        data.message;
                } catch (error) {
                    document.getElementById("result").textContent =
                        `Request failed: ${error.message}`;
                }
            }
        );
    </script>
</body>
</html>
)HTML";

        crow::response response(page);
        response.set_header("Content-Type", "text/html; charset=utf-8");
        return response;
    });

    CROW_ROUTE(app, "/api/message")
    ([] {
        return crow::json::wvalue{
            {"message", "Hello from C++"}
        };
    });

    app.bindaddr("127.0.0.1")
        .port(8080)
        .multithreaded()
        .run();

    return 0;
}
