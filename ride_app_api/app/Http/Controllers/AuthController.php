<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => $request->password,
        ]);

        return response()->json([
            'status' => true,
            'message' => 'Đăng ký thành công',
            'user' => $user
        ]);
    }

    public function login(Request $request)
    {
        if (Auth::attempt([
            'email' => $request->email,
            'password' => $request->password
        ])) {
            $user = Auth::user();

            return response()->json([
                'status' => true,
                'message' => 'Đăng nhập thành công',
                'user' => $user
            ]);
        }

        return response()->json([
            'status' => false,
            'message' => 'Sai email hoặc mật khẩu'
        ], 401);
    }
}
