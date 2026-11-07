<?php

namespace App\Console\Commands;

use App\Services\FinanceCalendarAlertSyncService;
use Illuminate\Console\Command;
use Throwable;

class SyncFinanceCalendarAlerts extends Command
{
    protected $signature = 'finance-calendar:sync
                            {--country=US,GB : Countries to import}
                            {--impact=high : Minimum impact level}
                            {--limit=50 : Maximum number of events}';

    protected $description = 'Sync upcoming economic calendar events into market alerts';

    public function handle(
        FinanceCalendarAlertSyncService $syncService
    ): int {
        $this->info('Syncing Finance Calendar events...');

        try {
            $count = $syncService->sync([
                'country' => $this->option('country'),
                'impact' => $this->option('impact'),
                'limit' => (int) $this->option('limit'),
            ]);

            $this->info("Successfully synced {$count} market alerts.");

            return self::SUCCESS;
        } catch (Throwable $exception) {
            $this->error('Finance Calendar sync failed.');
            $this->error($exception->getMessage());

            report($exception);

            return self::FAILURE;
        }
    }
}