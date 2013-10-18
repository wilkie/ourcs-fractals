require 'bundler'
Bundler.require

require 'RMagick'

SLOW   = 1.1
MEDIUM = 0.5
FAST   = 0.1

def render(server)
  (0...50).each do |i|
    system("cp public/frame_#{i}.gif public/server_#{server}.gif")
    sleep_amount = Thread.current[:sleep_time]
    sleep(sleep_amount)
  end
end

@@t = []
@@t << Thread.new do
  Thread.current[:sleep_time] = MEDIUM

  loop do
    render 0
  end
end
@@t << Thread.new do
  Thread.current[:sleep_time] = MEDIUM

  loop do
    render 1
  end
end
@@t << Thread.new do
  Thread.current[:sleep_time] = MEDIUM

  loop do
    render 2
  end
end

@@t.each {|t| t[:sleep_time] = MEDIUM }

def update(mine)
  @@t.each do |t|
    if t[:sleep_time] > mine
      t[:sleep_time] = mine
    end
  end
end

class Server < Sinatra::Base
  get '/slow/:server' do
    @@t[params[:server].to_i][:sleep_time] = SLOW

    update(SLOW)

    redirect '/'
  end

  get '/medium/:server' do
    @@t[params[:server].to_i][:sleep_time] = MEDIUM

    update(MEDIUM)

    redirect '/'
  end

  get '/fast/:server' do
    @@t[params[:server].to_i][:sleep_time] = FAST

    update(FAST)

    redirect '/'
  end

  get '/' do
    "<html><body><img id='image_0' src='server_0.gif'><br><a #{@@t[0][:sleep_time] == SLOW ? "" : "href='/slow/0'"}>Slow</a> | <a #{@@t[0][:sleep_time] == MEDIUM ? "" : "href='/medium/0'"}>Medium</a> | <a #{@@t[0][:sleep_time] == FAST ? "" : "href='/fast/0'"}>Fast</a><br><img id='image_1' src='server_1.gif'><br><a #{@@t[1][:sleep_time] == SLOW ? "" : "href='/slow/1'"}>Slow</a> | <a #{@@t[1][:sleep_time] == MEDIUM ? "" : "href='/medium/1'"}>Medium</a> | <a #{@@t[1][:sleep_time] == FAST ? "" : "href='/fast/1'"}>Fast</a><br><img id='image_2' src='server_2.gif'><br><a #{@@t[2][:sleep_time] == SLOW ? "" : "href='/slow/2'"}>Slow</a> | <a #{@@t[2][:sleep_time] == MEDIUM ? "" : "href='/medium/2'"}>Medium</a> | <a #{@@t[2][:sleep_time] == FAST ? "" : "href='/fast/2'"}>Fast</a><script src='app.js'></script></body></html>"
  end
end
