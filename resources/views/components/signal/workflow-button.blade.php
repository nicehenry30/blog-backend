@switch($signal->status)

    @case(\App\Models\Signal::STATUS_DRAFT)

        <form
            method="POST"
            action="{{ route('admin.signals.approve', $signal) }}"
        >
            @csrf
            @method('PATCH')

            <x-admin.button variant="primary">
                Approve
            </x-admin.button>

        </form>

        @break

    @case(\App\Models\Signal::STATUS_APPROVED)

        <form
            method="POST"
            action="{{ route('admin.signals.publish', $signal) }}"
        >
            @csrf
            @method('PATCH')

            <x-admin.button variant="success">
                Publish
            </x-admin.button>

        </form>

        @break

    @case(\App\Models\Signal::STATUS_PUBLISHED)

        <form
            method="POST"
            action="{{ route('admin.signals.start', $signal) }}"
        >
            @csrf
            @method('PATCH')

            <x-admin.button variant="primary">
                Start
            </x-admin.button>

        </form>

        @break

    @case(\App\Models\Signal::STATUS_RUNNING)

        <div class="flex flex-wrap gap-2">

            @if($signal->take_profit && !$signal->tp1_hit_at)

                <form
                    method="POST"
                    action="{{ route('admin.signals.tp1', $signal) }}"
                >
                    @csrf
                    @method('PATCH')

                    <x-admin.button variant="warning">
                        TP1
                    </x-admin.button>

                </form>

            @elseif($signal->tp1_hit_at)

                <span class="px-4 py-2 rounded-lg bg-green-100 text-green-700 font-medium">
                    ✓ TP1
                </span>

            @endif

            @if($signal->take_profit_2 && !$signal->tp2_hit_at)

                <form
                    method="POST"
                    action="{{ route('admin.signals.tp2', $signal) }}"
                >
                    @csrf
                    @method('PATCH')

                    <x-admin.button variant="warning">
                        TP2
                    </x-admin.button>

                </form>

            @elseif($signal->tp2_hit_at)

                <span class="px-4 py-2 rounded-lg bg-green-100 text-green-700 font-medium">
                    ✓ TP2
                </span>

            @endif

            @if($signal->take_profit_3 && !$signal->tp3_hit_at)

                <form
                    method="POST"
                    action="{{ route('admin.signals.tp3', $signal) }}"
                >
                    @csrf
                    @method('PATCH')

                    <x-admin.button variant="warning">
                        TP3
                    </x-admin.button>

                </form>

            @elseif($signal->tp3_hit_at)

                <span class="px-4 py-2 rounded-lg bg-green-100 text-green-700 font-medium">
                    ✓ TP3
                </span>

            @endif

            <a href="{{ route('admin.signals.close-form', $signal) }}">

                <x-admin.button variant="danger">
                    Close
                </x-admin.button>

            </a>

        </div>

        @break

    @case(\App\Models\Signal::STATUS_CLOSED)

        <form
            method="POST"
            action="{{ route('admin.signals.archive', $signal) }}"
        >
            @csrf
            @method('PATCH')

            <x-admin.button variant="secondary">
                Archive
            </x-admin.button>

        </form>

        @break

@endswitch