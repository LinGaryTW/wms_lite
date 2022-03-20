schema = {}
schema_path = File.join(Rails.root.to_s, '/app/controllers/schemas')
controller_forders = Dir[schema_path + '/*'].map { |dir| File.basename(dir) }
controller_forders.each do |controller|
  schema[controller] = {}
  actions = Dir[File.join(schema_path, '/', controller, '/*')].map { |f| File.basename(f) }
  actions.each do |action|
    file = File.read(File.join(schema_path, '/', controller, '/', action))
    schema[controller][action] = JSON.parse(file)
  end
end
Rails.application.config.json_shcema = schema
