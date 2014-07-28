require 'lotus/router'

app = Lotus::Router.new do
  get '/', to: ->(env) { [200, {}, [
		
		"app.path(:root):",
		"\n",
		app.path(:root),
		"\n\n",
		"app.url(:root):",
		"\n",
		app.url(:root),
		
  	]] }, as: :root
end

Rack::Server.run app: app, Port: 4000




