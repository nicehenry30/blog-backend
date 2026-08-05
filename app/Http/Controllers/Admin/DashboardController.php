<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\GuardianAccount;
use App\Models\Signal;
use App\Models\User;

class DashboardController extends Controller
{
    public function index()
    {
        return view('admin.dashboard', [

            'totalSignals' =>
                Signal::count(),

            'publishedSignals' =>
                Signal::where(
                    'status',
                    'Published',
                )->count(),

            'guardianAccounts' =>
                GuardianAccount::count(),

            'users' =>
                User::count(),

        ]);
    }
}

