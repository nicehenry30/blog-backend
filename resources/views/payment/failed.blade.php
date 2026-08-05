<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Failed</title>

    @vite(['resources/css/app.css'])
</head>

<body class="bg-slate-100">

<div class="min-h-screen flex items-center justify-center">

    <div class="bg-white rounded-xl shadow-xl p-10 max-w-lg w-full">

        <div class="text-center">

            <div class="text-6xl mb-6">
                ❌
            </div>

            <h1 class="text-3xl font-bold text-red-600">
                Payment Failed
            </h1>

            <p class="mt-4 text-gray-600">
                {{ $message }}
            </p>

        </div>

        <div class="mt-8">

            <a
                href="/"
                class="block text-center bg-slate-900 hover:bg-slate-800 text-white py-3 rounded-lg"
            >
                Back to Tradewisser
            </a>

        </div>

    </div>

</div>

</body>
</html>