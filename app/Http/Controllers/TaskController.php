<?php

namespace App\Http\Controllers;

use App\Models\Task;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class TaskController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth');
    }

    /**
     * Display a listing of the user's tasks.
     */
    public function index()
    {
        $tasks = Task::where('user_id', Auth::id())->with('category','subtasks')->latest()->get();

        return view('tasks.index', compact('tasks'));
    }

    /**
     * Store a newly created task.
     */
    public function store(Request $request)
    {
        $data = $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'category_id' => 'nullable|exists:categories,id',
            'status' => 'nullable|in:todo,in_progress,done',
            'priority' => 'nullable|in:low,medium,high,urgent',
            'due_date' => 'nullable|date',
        ]);

        $data['is_completed'] = ($data['status'] ?? 'todo') === 'done';
        $data['user_id'] = Auth::id();
        $task = Task::create($data);

        if ($request->wantsJson()) {
            return response()->json($task->load('category','subtasks'));
        }

        return redirect()->back()->with('success', 'Task created');
    }

    /**
     * Display the specified task.
     */
    public function show(Task $task)
    {
        $this->authorizeTaskOwner($task);

        return view('tasks.show', ['task' => $task->load('category','subtasks')]);
    }

    /**
     * Update the specified task.
     */
    public function update(Request $request, Task $task)
    {
        $this->authorizeTaskOwner($task);

        $data = $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'category_id' => 'nullable|exists:categories,id',
            'status' => 'nullable|in:todo,in_progress,done',
            'priority' => 'nullable|in:low,medium,high,urgent',
            'due_date' => 'nullable|date',
            'is_completed' => 'nullable|boolean',
        ]);

        if (isset($data['is_completed']) && $data['is_completed']) {
            $data['completed_at'] = now();
        } elseif (isset($data['is_completed']) && ! $data['is_completed']) {
            $data['completed_at'] = null;
        }

        $task->update($data);

        if ($request->wantsJson()) {
            return response()->json($task->fresh());
        }

        return redirect()->back()->with('success', 'Task updated');
    }

    /**
     * Remove the specified task.
     */
    public function destroy(Task $task)
    {
        $this->authorizeTaskOwner($task);

        $task->delete();

        return redirect()->back()->with('success', 'Task deleted');
    }

    protected function authorizeTaskOwner(Task $task)
    {
        if ($task->user_id !== Auth::id()) {
            abort(403);
        }
    }
}
