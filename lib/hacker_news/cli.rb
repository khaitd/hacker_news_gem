class HackerNews::CLI

  def call
   list_news
   menu
  end

  def list_news
     puts "Today's Hacker News:"
     @news = HackerNews::News.today
     @news.each.with_index(1) do |article, i|
       if i < 10
         print " #{i}. #{article.title} - "
       else
         print "#{i}. #{article.title} - "
       end

         print "SOURCE: #{article.source}".colorize(:blue).chomp
         puts  "- SCORE: #{article.rating}".colorize(:red)
     end
  end

  def menu
    puts "------------------MENU ITEMS----------------------"
    puts "1 - ENTER the number of the article that you want to link to. [1 - 30]"
    puts "2 - Enter S to SORT the LIST"
    puts "3 - Enter C access an articles comments"
    puts "4 - Enter E to to exit"
    puts "--------------------------------------------------"
        input = gets.chomp.downcase
        if input == 's'
          sort_news
          menu
        end
        if input == 'c'
           puts "Which article's comments do you want to access? [1 - 30]"
           input_comment = gets.chomp
           link_comments(input_comment)
           menu
        end
        if input.to_i > 0 && input.to_i <= 30
           link_news(input)
            menu
        end
        if input == "e"
          exit
        end
  end

  def sort_news
    @sorted_news = HackerNews::News.sort
    @news = @sorted_news
    @news.each.with_index(1) do |article, i|
      if i < 10
        print " #{i}. Score #{article.rating} ".colorize(:blue)
      else
          print "#{i}. Score #{article.rating} ".colorize(:blue)
      end
      puts  " #{article.title} - Source: #{article.source} "
    end
  end

  def exit
     puts "Later hacker!"
  end


  def link_comments(num)
     Launchy.open( "https://news.ycombinator.com/#{@news[num.to_i-1].comment_url}" )
  end

  def link_news(num)



    if @sorted_news
      @news = @sorted_news
      Launchy.open( "#{@news[num.to_i-1].source_url}" )
    else

      Launchy.open( "#{@news[num.to_i-1].source_url}" )
    end
    #  menu

#{news[num.to_i].source_url}
  end

end
