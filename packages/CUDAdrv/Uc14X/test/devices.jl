@testset "devices" begin

name(dev)
totalmem(dev)
attribute(dev, CUDAdrv.DEVICE_ATTRIBUTE_MAX_THREADS_PER_BLOCK)
@test warpsize(dev) == Int32(32)
capability(dev)
@grab_output show(stdout, "text/plain", dev)

@test eval(Meta.parse(repr(dev))) == dev

@test eltype(devices()) == CuDevice
@grab_output show(stdout, "text/plain", CUDAdrv.DEVICE_CPU) 
@grab_output show(stdout, "text/plain", CUDAdrv.DEVICE_INVALID) 
end
