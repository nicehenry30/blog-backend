<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Successful</title>

    @vite(['resources/css/app.css'])
</head>

<body class="bg-slate-100">

<div class="min-h-screen flex items-center justify-center">

    <div class="bg-white rounded-xl shadow-xl p-10 max-w-lg w-full">

        <div class="text-center">

            <div class="text-6xl mb-6">
                ✅
            </div>

            <h1 class="text-3xl font-bold text-green-600">
                Payment Successful
            </h1>

            <p class="mt-4 text-gray-600">
                Your subscription has been activated successfully.
            </p>

        </div>

        <div class="mt-8 border rounded-lg p-5">

            <div class="flex justify-between py-2">
                <span class="font-semibold">
                    Reference
                </span>

                <span>
                    {{ $payment->reference }}
                </span>
            </div>

            <div class="flex justify-between py-2">
                <span class="font-semibold">
                    Amount
                </span>

                <span>
                    {{ $payment->currency }}
                    {{ number_format($payment->amount, 2) }}
                </span>
            </div>

            <div class="flex justify-between py-2">
                <span class="font-semibold">
                    Status
                </span>

                <span class="text-green-600 font-bold">
                    {{ ucfirst($payment->status) }}
                </span>
            </div>

        </div>

        <div class="mt-8">

            <a
                href="/"
                class="block text-center bg-blue-600 hover:bg-blue-700 text-white py-3 rounded-lg"
            >
                Continue to Tradewisser
            </a>

        </div>

    </div>

</div>

</body>
</html>