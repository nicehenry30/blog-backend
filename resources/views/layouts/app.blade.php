<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tradewisser Admin</title>

    @vite([
        'resources/css/app.css',
        'resources/js/app.js',
    ])
</head>

<body class="bg-gray-100">

<div class="min-h-screen flex">

    <!-- Sidebar -->
<aside class="w-64 bg-slate-900 text-white">

    <div class="p-6 border-b border-slate-700">
        <h1 class="text-2xl font-bold">
            Tradewisser
        </h1>

        <p class="text-sm text-gray-400">
            Admin Panel
        </p>
    </div>

    <nav class="mt-6">

        <a href="#"
           class="block px-6 py-3 hover:bg-slate-800">
            📊 Dashboard
        </a>

        <a href="{{ route('admin.signals.index') }}"
           class="block px-6 py-3 hover:bg-slate-800">
            📈 Signals
        </a>

        <a href="#"
           class="block px-6 py-3 hover:bg-slate-800">
            📰 Market News
        </a>

        <a href="#"
           class="block px-6 py-3 hover:bg-slate-800">
            📚 Education
        </a>

        <a href="#"
           class="block px-6 py-3 hover:bg-slate-800">
            🛡 Guardian
        </a>

        <a href="#"
           class="block px-6 py-3 hover:bg-slate-800">
            👥 Users
        </a>

        <a href="#"
           class="block px-6 py-3 hover:bg-slate-800">
            ⭐ Reviews
        </a>

        <a href="{{ route('admin.plans.index') }}"
           class="block px-6 py-3 hover:bg-slate-800">
            💳 Subscription Plans
        </a>

        <a href="{{ route('admin.subscriptions.index') }}"
           class="block px-6 py-3 hover:bg-slate-800">
            👥 Subscriptions
        </a>

        <a
        href="{{ route('admin.payments.index') }}"
        class="block px-6 py-3 hover:bg-slate-800"
>
    💰 Payments
        </a>

        <a href="#"
           class="block px-6 py-3 hover:bg-slate-800">
            📊 Analytics
        </a>

        <a href="#"
           class="block px-6 py-3 hover:bg-slate-800">
            ⚙ Settings
        </a>

    </nav>

</aside>

    <!-- Main Content -->
    <div class="flex-1">

        <!-- Top Bar -->
        <header class="bg-white shadow">

            <div class="flex justify-between items-center p-6">

                <h2 class="text-2xl font-bold">
                    @yield('title')
                </h2>

               <div class="font-medium">
                    {{ auth()->user()?->name ?? 'Administrator' }}
                </div>

            </div>

        </header>

        <!-- Page -->
        <main class="p-8">

            @yield('content')

        </main>

    </div>

</div>

</body>
</html>

