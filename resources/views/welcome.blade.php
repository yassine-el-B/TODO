<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <title>TODO</title>

        <!-- Fonts -->
        <!DOCTYPE html>
        <html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1">

                <title>TODO</title>

                <!-- Fonts -->
                <link rel="preconnect" href="https://fonts.bunny.net">
                <link href="https://fonts.bunny.net/css?family=figtree:400,600&display=swap" rel="stylesheet" />

                <!-- Styles + Scripts -->
                @vite(['resources/css/app.css', 'resources/js/app.js'])
                @livewireStyles
            </head>
            <body class="antialiased font-sans bg-slate-50 text-slate-900 dark:bg-slate-900 dark:text-slate-200">
                <div class="min-h-screen flex flex-col">
                    <nav class="flex items-center justify-between px-6 py-4 border-b bg-white dark:bg-zinc-900">
                        <div class="flex items-center gap-3">
                            <x-app-logo-icon class="h-8 w-8 text-[#FF2D20]" />
                            <span class="font-semibold">TODO</span>
                        </div>
                        <div>
                            @if (Route::has('login'))
                                @auth
                                    <a href="{{ url('/dashboard') }}" class="px-4 py-2 rounded-md bg-slate-800 text-white">Dashboard</a>
                                @else
                                    <a href="{{ route('login') }}" class="px-4 py-2 rounded-md text-slate-700 hover:underline">Login</a>
                                    @if (Route::has('register'))
                                        <a href="{{ route('register') }}" class="ml-2 px-4 py-2 rounded-md bg-[#FF2D20] text-white">Register</a>
                                    @endif
                                @endauth
                            @endif
                        </div>
                    </nav>

                    <header class="flex-1 flex items-center justify-center px-6 py-12">
                        <div class="max-w-4xl w-full text-center">
                            <h1 class="text-4xl sm:text-5xl font-extrabold mb-4">Jouw persoonlijke TODO</h1>
                            <p class="text-lg text-slate-600 dark:text-slate-300 mb-8">Plan en beheer al je taken - werk, privé, boodschappen en alles daartussenin. Maak categorieën, voeg subtaken toe en houd voortgang bij.</p>

                            <div class="flex items-center justify-center gap-4">
                                @auth
                                    <a href="{{ url('/dashboard') }}" class="rounded-md bg-[#FF2D20] px-6 py-3 text-white font-semibold">Ga naar dashboard</a>
                                @else
                                    <a href="{{ route('register') }}" class="rounded-md bg-[#FF2D20] px-6 py-3 text-white font-semibold">Begin nu (gratis)</a>
                                    <a href="{{ route('login') }}" class="rounded-md border border-slate-200 px-6 py-3 text-slate-700">Ik heb al een account</a>
                                @endauth
                            </div>
                        </div>
                    </header>

                    <main class="py-12 px-6 bg-white dark:bg-zinc-900">
                        <div class="max-w-5xl mx-auto grid grid-cols-1 md:grid-cols-3 gap-6">
                            <div class="p-6 rounded-lg shadow-sm bg-slate-50 dark:bg-zinc-800">
                                <h3 class="font-semibold mb-2">Snel notities</h3>
                                <p class="text-sm text-slate-600 dark:text-slate-300">Stop dingen in de "Open" categorie of maak nieuwe categorieën aan om alles georganiseerd te houden.</p>
                            </div>
                            <div class="p-6 rounded-lg shadow-sm bg-slate-50 dark:bg-zinc-800">
                                <h3 class="font-semibold mb-2">Subtaken & voortgang</h3>
                                <p class="text-sm text-slate-600 dark:text-slate-300">Breek grote taken in stapjes en zie hoeveel er afgerond is.</p>
                            </div>
                            <div class="p-6 rounded-lg shadow-sm bg-slate-50 dark:bg-zinc-800">
                                <h3 class="font-semibold mb-2">API & integraties</h3>
                                <p class="text-sm text-slate-600 dark:text-slate-300">Gebruik de API voor externe tools of mobiele apps (JSON endpoints beschikbaar).</p>
                            </div>
                        </div>
                    </main>

                    <footer class="py-6 text-center text-sm text-slate-500 border-t bg-white dark:bg-zinc-900">
                        © {{ date('Y') }} TODO App — Gemaakt met Laravel
                    </footer>
                </div>

                @livewireScripts
            </body>
        </html>

