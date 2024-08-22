local M = {}

local template = "{{{prompt}}}\n{{{guidelines}}}\n{{{n_completion_template}}}"
local n_completion_template = "7. Provide at most %d completion items."

local function prompt_by_ft(ft)
  if ft == "tex" then
    return [[
You are the backend of an AI-powered prose completion engine. You are an
excellent write in the english language and author scientific manuscripts. Your
task is to provide suggestions on how to complete a given text based on the
user's input. The user's text will be enclosed in markers:

- `<contextAfterCursor>`: Text context after the cursor
- `<cursorPosition>`: Current cursor location
- `<contextBeforeCursor>`: Text context before the cursor

Note that the user's text will be prompted in reverse order: first the text
after the cursor, then the text before the cursor.
]]
  elseif ft == "mail" then
    return [[
You are the backend of an AI-powered email completion engine. You are an
excellent write in the english and swedish languages and author professioneal
and relaxed emails. Your task is to provide suggestions on how to complete a
given text based on the user's input. The user's text will be enclosed in markers:

- `<contextAfterCursor>`: Text context after the cursor
- `<cursorPosition>`: Current cursor location
- `<contextBeforeCursor>`: Text context before the cursor

Note that the user's text will be prompted in reverse order: first the text
after the cursor, then the text before the cursor.
]]
  else -- assume code
    return [[
You are the backend of an AI-powered code completion engine. Your task is to
provide code suggestions based on the user's input. The user's code will be
enclosed in markers:

- `<contextAfterCursor>`: Code context after the cursor
- `<cursorPosition>`: Current cursor location
- `<contextBeforeCursor>`: Code context before the cursor

Note that the user's code will be prompted in reverse order: first the code
after the cursor, then the code before the cursor.
]]
  end
end

local function guidelines_by_ft(ft)
  if ft == "tex" then
    return [[
Guidelines:
1. Offer completions after the `<cursorPosition>` marker.
2. Make sure you have maintained the user's existing whitespace and indentation.
   This is REALLY IMPORTANT!
3. Provide multiple completion options when possible.
4. Return completions separated by the marker <endCompletion>.
5. The returned message will be further parsed and processed. DO NOT include
   additional comments or markdown code block fences. Return the result directly.
6. Keep each completion option concise, limiting it to a single line or a few lines.]]
  elseif ft == "mail" then
    return [[
Guidelines:
1. Offer completions after the `<cursorPosition>` marker.
2. Make sure you have maintained the user's existing whitespace and indentation.
   This is REALLY IMPORTANT!
3. Provide multiple completion options when possible.
4. Return completions separated by the marker <endCompletion>.
5. The returned message will be further parsed and processed. DO NOT include
   additional comments or markdown code block fences. Return the result directly.
6. Keep each completion option concise, limiting it to a single line or a few lines.]]
  else -- assume code
    return [[
Guidelines:
1. Offer completions after the `<cursorPosition>` marker.
2. Make sure you have maintained the user's existing whitespace and indentation.
   This is REALLY IMPORTANT!
3. Provide multiple completion options when possible.
4. Return completions separated by the marker <endCompletion>.
5. The returned message will be further parsed and processed. DO NOT include
   additional comments or markdown code block fences. Return the result directly.
6. Keep each completion option concise, limiting it to a single line or a few lines.]]
  end
end

M.minuet_system_prompt = function(ft)
  return {
    template = template,
    prompt = prompt_by_ft(ft),
    guidelines = guidelines_by_ft(ft),
    n_completion_template = n_completion_template,
  }
end

M.minuet_few_shot = function(ft)
  if ft == "tex" then
    return {
      {
        role = "user",
        content = [[
% language: latex
<contextAfterCursor>

This technique is widely used in various domains, such as finance, healthcare,
and speech recognition, where understanding temporal dynamics is crucial for
making accurate predictions.
<contextBeforeCursor>
Time series classification is a specialized area of machine learning that
focuses on categorizing sequences of data points collected or recorded at
successive points in time. Unlike traditional classification tasks
  <cursorPosition>]],
      },
      {
        role = "assistant",
        content = [[
, time series data has an inherent temporal order, which adds complexity due to
the potential dependencies between different time points.
<endCompletion>
, time series data is inherently sequential, adding complexity because of the
potential interdependencies between different time points.
<endCompletion>
]],
      },
    }
  elseif ft == "mail" then
    return {
      {
        role = "user",
        content = [[
% language: markdown
<contextAfterCursor>
Understanding the timeline will help me manage the project more effectively and
ensure that all necessary work is completed on time.

Thank you for your guidance and assistance. I look forward to your response.
<contextBeforeCursor>
I am currently working on the time series classification project, and I wanted
to clarify a couple of details to ensure that I am on the right track.
Specifically,  <cursorPosition>]],
      },
      {
        role = "assistant",
        content = [[
I would appreciate it if you could provide some information regarding the
submission deadline for the paper related to this project.
<endCompletion>
I would be grateful if you could share the details about the submission
deadline for the paper associated with this project.
<endCompletion>
]],
      },
    }
  else
    return {
      {
        role = "user",
        content = [[
# language: python
<contextAfterCursor>

fib(5)
<contextBeforeCursor>
def fibonacci(n):
    <cursorPosition>]],
      },
      {
        role = "assistant",
        content = [[
    '''
    Recursive Fibonacci implementation
    '''
    if n < 2:
        return n
    return fib(n - 1) + fib(n - 2)
<endCompletion>
    '''
    Iterative Fibonacci implementation
    '''
    a, b = 0, 1
    for _ in range(n):
        a, b = b, a + b
    return a
<endCompletion>
]],
      },
    }
  end
end

return M
