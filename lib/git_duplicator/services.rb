module GitDuplicator
  # Load all implemented services
  module Services
    Dir[File.dirname(__FILE__) + '/services/**/*.rb'].each do |file|
      # Get camelized class name
      filename = File.basename(file, '.rb')
      # Add _gateway suffix
      gateway_name = filename + '_repository'
      # Camelize the string to get the class name
      gateway_class = gateway_name.split('_').map(&:capitalize).join
      # Register for autoloading
      autoload gateway_class, file
    end
  end
end
