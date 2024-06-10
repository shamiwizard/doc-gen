require 'openai'

class AiClient
  attr_reader :last_message

  API_KEY = ""

  def initialize
    @client = OpenAI::Client.new(access_token: AiClient::API_KEY)
  end

  def generate_documentation(file_name, code)
    prompt = <<-TEXT
      Дано наступний код із файлу #{file_name}:
      #{code}

      Згенеруй документaцію в людському стилі на основі наданого коду.
      Документaція повинна бути написана як опис того, що робить цей код, щоб не технічна людина або особа, яка не знайома з додатком, могла її зрозуміти.
      Наприкінці документaція може включати більш технічні речі, такі як інформація про API, використовувані класи, бібліотеки.

      Структура документaції повинна бути наступною:

      # Опис функціональності
      # Технічний опис
        - Заголовок
        - Детальний опис
        - Якщо код використовує елементи з інших файлів або бібліотек, вкажіть і опишіть ці залежності [ClassName](#{file_name}/ClassName),
        - Якщо згадується ім'я класу, модуля, методу, використовуйте кодовий формат для нього `ClassName`
        - Використовуйте цитати для конкретних умов > Примітка: користувач повинен мати постачальника платежів sage
        - Використовуйте маркери, щоб пояснити щось, що має два різні стани або випадки
        - Використовуйте нумерований список тільки для опису кроків, як щось працює

      Будь ласка, переконайтеся, що документація є всебічною і легкою для розуміння.
    TEXT

    response = client.chat(
      parameters: {
          model: "gpt-4o",
          messages: [
            { role: 'system', content: 'Act as a product owner of the project which gona describe have his app works' },
            { role: "user", content: prompt }
          ],
          temperature: 0.5,
      })

    @last_message = response.dig("choices", 0, "message", "content").strip
  end

  def edit_doc(code_file_path:, code:, doc:, edit_prompt:)
    prompt = <<-TEXT
      Given the following code, previously generated documentation and user prompt
      Based on the given information, update the documentation by user prompt.
      Prompt: #{edit_prompt}
      File path: #{code_file_path}:

      Documentation:
      #{doc}

      Code:
      #{code}

      Документaція повинна бути написана як опис того, що робить цей код, щоб не технічна людина або особа, яка не знайома з додатком, могла її зрозуміти.
      Наприкінці документaція може включати більш технічні речі, такі як інформація про API, використовувані класи, бібліотеки.

      Структура документaції повинна бути наступною:

      # Опис функціональності
      # Технічний опис
        - Заголовок
        - Детальний опис
        - Якщо код використовує елементи з інших файлів або бібліотек, вкажіть і опишіть ці залежності [ClassName](#{file_name}/ClassName),
        - Якщо згадується ім'я класу, модуля, методу, використовуйте кодовий формат для нього `ClassName`
        - Використовуйте цитати для конкретних умов > Примітка: користувач повинен мати постачальника платежів sage
        - Використовуйте маркери, щоб пояснити щось, що має два різні стани або випадки
        - Використовуйте нумерований список тільки для опису кроків, як щось працює

      Будь ласка, переконайтеся, що документація є всебічною і легкою для розуміння.
    TEXT

    response = client.chat(
      parameters: {
          model: "gpt-4o",
          messages: [
            { role: 'system', content: 'Act as a product owner of the project which gona describe have his app works' },
            { role: "user", content: prompt }
          ],
          temperature: 0.5,
      })
    @last_message = response.dig("choices", 0, "message", "content").strip
  end

  private

  attr_reader :client
end


# prompt = <<-TEXT
#       Given the following code from file #{file_name}:
#       #{code}

#       Generate human-like documentation based on the code provided.
#       Documentation must be written as description of what the code does. So non-technical or person which is not familiar with app can understand it.
#       At the end the documentation can include more technical things like info about API, uses classes, libs.

#       The structure of the documentation should be:

#       ## Name of the file #{file_name}
#       # Description of the functionality
#       # Technical Description
#         - A title
#         - A detailed description
#         - If the code uses elements from other files or libraries, mention and describe those dependencies [ClassName](#{file_name}/ClassName),
#         - If name of the class, module, method mention use code format for it `ClassName`
#         - Use quote if there are some specific conditions > Note: user must have sage payment provider
#         - Use bullets to explain something which have two different states or cases
#         - use numerick list only to describe steps how something works

#       Please ensure the documentation is comprehensive and easy to understand.
#     TEXT
