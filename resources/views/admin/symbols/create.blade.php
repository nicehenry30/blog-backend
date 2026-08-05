<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Symbol;

class SymbolSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $symbols = [

            // Metals
            [
                'symbol' => 'XAUUSD',
                'name' => 'Gold',
                'asset_type' => 'Metal',
                'broker_symbol' => 'XAUUSD',
                'digits' => 2,
                'active' => true,
            ],

            [
                'symbol' => 'XAGUSD',
                'name' => 'Silver',
                'asset_type' => 'Metal',
                'broker_symbol' => 'XAGUSD',
                'digits' => 3,
                'active' => true,
            ],

            // Forex
            [
                'symbol' => 'EURUSD',
                'name' => 'Euro / US Dollar',
                'asset_type' => 'Forex',
                'broker_symbol' => 'EURUSD',
                'digits' => 5,
                'active' => true,
            ],

            [
                'symbol' => 'GBPUSD',
                'name' => 'British Pound / US Dollar',
                'asset_type' => 'Forex',
                'broker_symbol' => 'GBPUSD',
                'digits' => 5,
                'active' => true,
            ],

            [
                'symbol' => 'USDJPY',
                'name' => 'US Dollar / Japanese Yen',
                'asset_type' => 'Forex',
                'broker_symbol' => 'USDJPY',
                'digits' => 3,
                'active' => true,
            ],

            // Crypto
            [
                'symbol' => 'BTCUSD',
                'name' => 'Bitcoin',
                'asset_type' => 'Crypto',
                'broker_symbol' => 'BTCUSD',
                'digits' => 2,
                'active' => true,
            ],

            [
                'symbol' => 'ETHUSD',
                'name' => 'Ethereum',
                'asset_type' => 'Crypto',
                'broker_symbol' => 'ETHUSD',
                'digits' => 2,
                'active' => true,
            ],

            // Indices
            [
                'symbol' => 'NAS100',
                'name' => 'Nasdaq 100',
                'asset_type' => 'Index',
                'broker_symbol' => 'USTEC',
                'digits' => 1,
                'active' => true,
            ],

            [
                'symbol' => 'US30',
                'name' => 'Dow Jones',
                'asset_type' => 'Index',
                'broker_symbol' => 'US30',
                'digits' => 1,
                'active' => true,
            ],

            // Commodities
            [
                'symbol' => 'WTI',
                'name' => 'Crude Oil',
                'asset_type' => 'Commodity',
                'broker_symbol' => 'USOIL',
                'digits' => 2,
                'active' => true,
            ],

        ];

        foreach ($symbols as $symbol) {
            Symbol::updateOrCreate(
                ['symbol' => $symbol['symbol']],
                $symbol
            );
        }
    }
}