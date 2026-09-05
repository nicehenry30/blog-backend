
@extends('layouts.app')

@section('title', 'Feedback Details')

@section('content')

<div class="container-fluid">

    <div class="d-flex justify-content-between align-items-center mb-4">

        <div>

            <h3 class="mb-1">
                Feedback #{{ $feedback->id }}
            </h3>

            <p class="text-muted mb-0">

                Submitted by
                <strong>{{ $feedback->user?->name }}</strong>

                @if($feedback->user?->email)
                    ({{ $feedback->user->email }})
                @endif

            </p>

        </div>

        <a
            href="{{ route('admin.feedback.index') }}"
            class="btn btn-outline-secondary"
        >
            Back
        </a>

    </div>


    @if(session('success'))

        <div class="alert alert-success">
            {{ session('success') }}
        </div>

    @endif


    <div class="row">

        <div class="col-lg-7">

            <div class="card shadow-sm mb-4">

                <div class="card-header">
                    User Feedback
                </div>

                <div class="card-body">

                    <div class="mb-3">

                        <strong>Category</strong>

                        <div class="mt-1">

                            <span class="badge bg-secondary text-uppercase">
                                {{ $feedback->category }}
                            </span>

                        </div>

                    </div>


                    <div class="mb-3">

                        <strong>Subject</strong>

                        <div class="mt-1">
                            {{ $feedback->subject }}
                        </div>

                    </div>


                    <div>

                        <strong>Message</strong>

                        <div class="mt-2 p-3 bg-light rounded">

                            {!! nl2br(e($feedback->message)) !!}

                        </div>

                    </div>

                </div>

            </div>

        </div>


        <div class="col-lg-5">

            <div class="card shadow-sm">

                <div class="card-header">
                    Admin Response
                </div>

                <div class="card-body">

                    <form
                        method="POST"
                        action="{{ route('admin.feedback.update', $feedback) }}"
                    >

                        @csrf
                        @method('PUT')


                        <div class="mb-3">

                            <label class="form-label">
                                Status
                            </label>

                            <select
                                name="status"
                                class="form-select"
                            >

                                <option
                                    value="pending"
                                    @selected($feedback->status === 'pending')
                                >
                                    Pending
                                </option>

                                <option
                                    value="in_progress"
                                    @selected($feedback->status === 'in_progress')
                                >
                                    In Progress
                                </option>

                                <option
                                    value="resolved"
                                    @selected($feedback->status === 'resolved')
                                >
                                    Resolved
                                </option>

                                <option
                                    value="closed"
                                    @selected($feedback->status === 'closed')
                                >
                                    Closed
                                </option>

                            </select>

                        </div>


                        <div class="mb-3">

                            <label class="form-label">
                                Reply
                            </label>

                            <textarea
                                name="admin_reply"
                                rows="8"
                                class="form-control"
                                placeholder="Write your response to the user..."
                            >{{ old('admin_reply', $feedback->admin_reply) }}</textarea>

                        </div>


                        @if($feedback->replied_at)

                            <div class="alert alert-light border">

                                <small class="text-muted">

                                    Last replied:

                                    {{ $feedback->replied_at->format('d M Y H:i') }}

                                </small>

                            </div>

                        @endif


                        <button
                            class="btn btn-primary w-100"
                            type="submit"
                        >
                            Save Response
                        </button>

                    </form>

                </div>

            </div>

        </div>

    </div>

</div>

@endsection