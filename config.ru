require 'lotus'
require 'json'

module OneFile
  class Application < Lotus::Application
    configure do
      routes do
        get '/', to: 'home#index'
      end
    end

    load!
  end

  module Controllers
    module Home
      include OneFile::Controller

      action 'Index' do
        def call(params)
          self.status  = 201
          self.body    = JSON.dump({'Hi!'=>'Hi!'})
          self.headers.merge!({ 'X-Custom' => 'OK' })
        end
      end
    end
  end

end

run OneFile::Application.new