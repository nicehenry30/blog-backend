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

            // ===============================
            // FOREX
            // ===============================

            ['symbol'=>'EURUSD','name'=>'Euro / US Dollar','asset_type'=>'Forex','digits'=>5],
            ['symbol'=>'GBPUSD','name'=>'British Pound / US Dollar','asset_type'=>'Forex','digits'=>5],
            ['symbol'=>'USDJPY','name'=>'US Dollar / Japanese Yen','asset_type'=>'Forex','digits'=>3],
            ['symbol'=>'USDCHF','name'=>'US Dollar / Swiss Franc','asset_type'=>'Forex','digits'=>5],
            ['symbol'=>'USDCAD','name'=>'US Dollar / Canadian Dollar','asset_type'=>'Forex','digits'=>5],
            ['symbol'=>'AUDUSD','name'=>'Australian Dollar / US Dollar','asset_type'=>'Forex','digits'=>5],
            ['symbol'=>'NZDUSD','name'=>'New Zealand Dollar / US Dollar','asset_type'=>'Forex','digits'=>5],

            // ===============================
            // METALS
            // ===============================

            ['symbol'=>'XAUUSD','name'=>'Gold','asset_type'=>'Metal','digits'=>2],
            ['symbol'=>'XAGUSD','name'=>'Silver','asset_type'=>'Metal','digits'=>3],

            // ===============================
            // INDICES
            // ===============================

            ['symbol'=>'NAS100','name'=>'Nasdaq 100','asset_type'=>'Index','digits'=>1],
            ['symbol'=>'US30','name'=>'Dow Jones','asset_type'=>'Index','digits'=>1],
            ['symbol'=>'SPX500','name'=>'S&P 500','asset_type'=>'Index','digits'=>1],
            ['symbol'=>'GER40','name'=>'DAX 40','asset_type'=>'Index','digits'=>1],
            ['symbol'=>'UK100','name'=>'FTSE 100','asset_type'=>'Index','digits'=>1],

            // ===============================
            // CRYPTO
            // ===============================

            ['symbol'=>'BTCUSD','name'=>'Bitcoin','asset_type'=>'Crypto','digits'=>2],
            ['symbol'=>'ETHUSD','name'=>'Ethereum','asset_type'=>'Crypto','digits'=>2],
            ['symbol'=>'SOLUSD','name'=>'Solana','asset_type'=>'Crypto','digits'=>2],

            // ===============================
            // COMMODITIES
            // ===============================

            ['symbol'=>'WTI','name'=>'Crude Oil WTI','asset_type'=>'Commodity','digits'=>2],
            ['symbol'=>'BRENT','name'=>'Brent Oil','asset_type'=>'Commodity','digits'=>2],

        ];

        foreach ($symbols as $symbol) {

            Symbol::updateOrCreate(

                [
                    'symbol' => $symbol['symbol'],
                ],

                [
                    'name' => $symbol['name'],
                    'asset_type' => $symbol['asset_type'],
                    'digits' => $symbol['digits'],
                    'active' => true,
                ]

            );

        }
    }
}