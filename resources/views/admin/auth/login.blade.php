<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0"
    >

    <title>Tradewisser Admin Login</title>

    @vite([
        'resources/css/app.css',
        'resources/js/app.js',
    ])
</head>

<body class="min-h-screen bg-gray-100 flex items-center justify-center">

    <div class="w-full max-w-md px-6">

        <div class="bg-white rounded-2xl shadow-lg p-8">

            {{-- Header --}}
            <div class="text-center mb-8">

                <h1 class="text-3xl font-bold text-slate-900">
                    Tradewisser
                </h1>

                <p class="text-gray-500 mt-2">
                    Administrator Login
                </p>

            </div>


            {{-- Login Errors --}}
            @if ($errors->any())

                <div class="bg-red-100 border border-red-300 text-red-800 rounded-lg p-4 mb-6">

                    <ul class="list-disc list-inside text-sm space-y-1">

                        @foreach ($errors->all() as $error)

                            <li>
                                {{ $error }}
                            </li>

                        @endforeach

                    </ul>

                </div>

            @endif


            {{-- Login Form --}}
            <form
                method="POST"
                action="{{ route('admin.login.submit') }}"
                class="space-y-6"
            >

                @csrf


                {{-- Email --}}
                <div>

                    <label
                        for="email"
                        class="block text-sm font-medium text-gray-700 mb-2"
                    >
                        Email Address
                    </label>

                    <input
                        id="email"
                        type="email"
                        name="email"
                        value="{{ old('email') }}"
                        required
                        autofocus
                        autocomplete="email"
                        class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-slate-800 focus:border-slate-800 outline-none"
                        placeholder="admin@example.com"
                    >

                </div>


                {{-- Password --}}
                <div>

                    <label
                        for="password"
                        class="block text-sm font-medium text-gray-700 mb-2"
                    >
                        Password
                    </label>

                    <input
                        id="password"
                        type="password"
                        name="password"
                        required
                        autocomplete="current-password"
                        class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-slate-800 focus:border-slate-800 outline-none"
                        placeholder="Enter your password"
                    >

                </div>


                {{-- Submit --}}
                <button
                    type="submit"
                    class="w-full bg-slate-900 hover:bg-slate-800 text-white font-semibold py-3 rounded-lg transition"
                >
                    Sign In
                </button>

            </form>

        </div>

        <p class="text-center text-sm text-gray-500 mt-6">
            Tradewisser Administration
        </p>

    </div>

</body>
</html>