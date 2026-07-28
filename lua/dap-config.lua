local dap = require("dap")
local dapui = require("dapui")

-- Python adapter (Mason-installed debugpy)
dap.adapters.python = {
  type = "executable",
  command = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python",
  args = { "-m", "debugpy.adapter" },
}

-- TCP adapter for attaching to a running debugpy server (e.g. Docker on port 5678)
dap.adapters.python_remote = {
  type = "server",
  host = "127.0.0.1",
  port = 5678,
}

-- pythonPath helper: prefer .venv in cwd, fall back to system python3
local function python_path()
  local venv = vim.fn.getcwd() .. "/.venv/bin/python"
  if vim.fn.executable(venv) == 1 then return venv end
  return vim.fn.exepath("python3") or vim.fn.exepath("python")
end

dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    pythonPath = python_path,
  },
  {
    type = "python",
    request = "launch",
    name = "Launch with args",
    program = "${file}",
    args = function()
      local input = vim.fn.input("Args: ")
      return vim.split(input, " ", { trimempty = true })
    end,
    pythonPath = python_path,
  },
  {
    type       = "python_remote",
    request    = "attach",
    name       = "Attach to Docker (port 5678)",
    subProcess = true,
    pathMappings = {
      {
        localRoot  = vim.fn.getcwd(),
        remoteRoot = "/app",
      },
    },
  },
}

-- DAP UI
dapui.setup()

-- Auto open/close UI with session lifecycle
dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"]     = function() dapui.close() end

-- Keymaps
vim.keymap.set("n", "<leader>dc", dap.continue,          { noremap = true, silent = true, desc = "DAP: Continue / Start" })
vim.keymap.set("n", "<leader>ds", dap.step_over,         { noremap = true, silent = true, desc = "DAP: Step over" })
vim.keymap.set("n", "<leader>di", dap.step_into,         { noremap = true, silent = true, desc = "DAP: Step into" })
vim.keymap.set("n", "<leader>do", dap.step_out,          { noremap = true, silent = true, desc = "DAP: Step out" })
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { noremap = true, silent = true, desc = "DAP: Toggle breakpoint" })
vim.keymap.set("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Condition: "))
end,                                                       { noremap = true, silent = true, desc = "DAP: Conditional breakpoint" })
vim.keymap.set("n", "<leader>dr", dap.repl.open,         { noremap = true, silent = true, desc = "DAP: Open REPL" })
vim.keymap.set("n", "<leader>du", dapui.toggle,          { noremap = true, silent = true, desc = "DAP: Toggle UI" })
vim.keymap.set("n", "<leader>dx", dap.terminate,         { noremap = true, silent = true, desc = "DAP: Terminate session" })
