class VesselFrench

  include Vessel

  def initialize id = 0

    super

    @name = "French"
    @path = File.expand_path(File.join(File.dirname(__FILE__), "/"))
    @docs = "A French language study tool."

    install(:primary, :study)
    install(:generic, :help)
    install(:generic, :document)

  end

end
