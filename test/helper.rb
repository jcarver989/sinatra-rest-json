class FooModel

  @@models = []
  @@next_id = 1

  attr_accessor :id, :name, :errors

  class << self
    def table_name
      "foo_models"
    end

    def all
      @@models
    end

    def destroy_all
      @@models = []
      @@next_id = 1
    end

    def find(id)
      @@models.select { |m| m.id == id }.first
    end

    def create(params)
      @@models << FooModel.new(@@next_id, params[:name])
      @@next_id += 1
      @@models[-1]
    end
  end

  def initialize(*args)
    if args.size == 0
      @id = nil
      @name = nil
    elsif args.size == 2
      @id = args[0].to_i
      @name = args[1]
    else args.size == 1
      update_attributes(args[0])
    end
  end

  def save
    if @name.nil?
      @errors = [
        { :name => "cant be blank" }
      ]

      false
    else 
      @@models << self
      self.id = @@next_id
      @@next_id += 1

      true
    end
  end

  def update_attributes(hash)
    unless hash.empty?
      @id = hash['id'].to_i if hash.include?('id')
      @name = hash['name'] if hash.include?('name')
    end
  end

  def destroy
    @@models.delete(self)
    self
  end

  def to_json
    { :id => @id, :name => @name }.to_json
  end
end

