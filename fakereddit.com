<!DOCTYPE html>
<html>
<head>
    <title>Welcome to FakeReddit.com</title>
    <style>
        :root {
            --c-fg: greenyellow;
            --c-bg: black;
        }

        body, a {
            background-color: var(--c-bg);
            color: var(--c-fg);
        }

        a {
            text-decoration: none;
        }
    </style>
</head>

<body>
    <h1>Welcome to FakeReddit.com</h1>
</body>

</html>
