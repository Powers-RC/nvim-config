local dap = require("dap")
local dapui = require("dapui")

-- Python adapter (Mason-installed debugpy)
dap.adapters.python = {
  type = "executable",
  command = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python",
  args = { "-m", "debugpy.adapter" },
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
}

-- DAP UI
dapui.setup()

-- Auto open/close UI with session lifecycle
dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"]     = function() dapui.close() end

-- Keymaps
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>dc", dap.continue,          opts) -- Continue / Start
vim.keymap.set("n", "<leader>ds", dap.step_over,         opts) -- Step over
vim.keymap.set("n", "<leader>di", dap.step_into,         opts) -- Step into
vim.keymap.set("n", "<leader>do", dap.step_out,          opts) -- Step out
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, opts) -- Toggle breakpoint
vim.keymap.set("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Condition: "))
end, opts)                                                      -- Conditional breakpoint
vim.keymap.set("n", "<leader>dr", dap.repl.open,         opts) -- Open REPL
vim.keymap.set("n", "<leader>du", dapui.toggle,          opts) -- Toggle UI
vim.keymap.set("n", "<leader>dx", dap.terminate,         opts) -- Terminate session
