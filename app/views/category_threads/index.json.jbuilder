# frozen_string_literal: true

json.threads @category_threads.map do |thread|
  json.id thread.id
  json.title thread.title
  json.category thread.category.name
  json.author thread.author.username
  json.createdAt thread.created_at
end
