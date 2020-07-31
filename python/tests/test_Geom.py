import copy

import pytest
import numpy as np

from damask import Geom
from damask import Rotation
from damask import util


def geom_equal(a,b):
    return np.all(a.get_microstructure() == b.get_microstructure()) and \
           np.all(a.get_grid()           == b.get_grid()) and \
           np.allclose(a.get_size(), b.get_size())

@pytest.fixture
def default():
    """Simple geometry."""
    x=np.concatenate((np.ones(40,dtype=int),
                      np.arange(2,42),
                      np.ones(40,dtype=int)*2,
                      np.arange(1,41))).reshape(8,5,4)
    return Geom(x,[8e-6,5e-6,4e-6])

@pytest.fixture
def reference_dir(reference_dir_base):
    """Directory containing reference results."""
    return reference_dir_base/'Geom'


class TestGeom:

    def test_update(self,default):
        modified = copy.deepcopy(default)
        modified.update(
                        default.get_microstructure(),
                        default.get_size(),
                        default.get_origin()
                       )
        print(modified)
        assert geom_equal(modified,default)


    def test_write_read_str(self,default,tmpdir):
        default.to_file(str(tmpdir.join('default.geom')))
        new = Geom.from_file(str(tmpdir.join('default.geom')))
        assert geom_equal(new,default)

    def test_write_read_file(self,default,tmpdir):
        with open(tmpdir.join('default.geom'),'w') as f:
            default.to_file(f)
        with open(tmpdir.join('default.geom')) as f:
            new = Geom.from_file(f)
        assert geom_equal(new,default)

    @pytest.mark.parametrize('pack',[True,False])
    def test_pack(self,default,tmpdir,pack):
        default.to_file(tmpdir.join('default.geom'),pack=pack)
        new = Geom.from_file(tmpdir.join('default.geom'))
        assert geom_equal(new,default)

    def test_invalid_combination(self,default):
        with pytest.raises(ValueError):
            default.update(default.microstructure[1:,1:,1:],size=np.ones(3), rescale=True)

    def test_invalid_size(self,default):
        with pytest.raises(ValueError):
            default.update(default.microstructure[1:,1:,1:],size=np.ones(2))

    def test_invalid_microstructure(self,default):
        with pytest.raises(ValueError):
            default.update(default.microstructure[1])

    def test_invalid_homogenization(self,default):
        with pytest.raises(TypeError):
            default.set_homogenization(homogenization=0)

    @pytest.mark.parametrize('directions,reflect',[
                                                   (['x'],        False),
                                                   (['x','y','z'],True),
                                                   (['z','x','y'],False),
                                                   (['y','z'],    False)
                                                  ]
                            )
    def test_mirror(self,default,update,reference_dir,directions,reflect):
        modified = copy.deepcopy(default)
        modified.mirror(directions,reflect)
        tag = f'directions={"-".join(directions)}_reflect={reflect}'
        reference = reference_dir/f'mirror_{tag}.geom'
        if update: modified.to_file(reference)
        assert geom_equal(modified,Geom.from_file(reference))

    @pytest.mark.parametrize('stencil',[1,2,3,4])
    def test_clean(self,default,update,reference_dir,stencil):
        modified = copy.deepcopy(default)
        modified.clean(stencil)
        tag = f'stencil={stencil}'
        reference = reference_dir/f'clean_{tag}.geom'
        if update: modified.to_file(reference)
        assert geom_equal(modified,Geom.from_file(reference))

    @pytest.mark.parametrize('grid',[
                                     (10,11,10),
                                     [10,13,10],
                                     np.array((10,10,10)),
                                     np.array((8, 10,12)),
                                     np.array((5, 4, 20)),
                                     np.array((10,20,2))
                                    ]
                            )
    def test_scale(self,default,update,reference_dir,grid):
        modified = copy.deepcopy(default)
        modified.scale(grid)
        tag = f'grid={util.srepr(grid,"-")}'
        reference = reference_dir/f'scale_{tag}.geom'
        if update: modified.to_file(reference)
        assert geom_equal(modified,Geom.from_file(reference))

    def test_renumber(self,default):
        modified = copy.deepcopy(default)
        microstructure = modified.get_microstructure()
        for m in np.unique(microstructure):
            microstructure[microstructure==m] = microstructure.max() + np.random.randint(1,30)
        modified.update(microstructure)
        assert not geom_equal(modified,default)
        modified.renumber()
        assert geom_equal(modified,default)

    def test_substitute(self,default):
        modified = copy.deepcopy(default)
        microstructure = modified.get_microstructure()
        offset = np.random.randint(1,500)
        microstructure+=offset
        modified.update(microstructure)
        assert not geom_equal(modified,default)
        modified.substitute(np.arange(default.microstructure.max())+1+offset,
                            np.arange(default.microstructure.max())+1)
        assert geom_equal(modified,default)

    @pytest.mark.parametrize('axis_angle',[np.array([1,0,0,86.7]), np.array([0,1,0,90.4]), np.array([0,0,1,90]),
                                           np.array([1,0,0,175]),np.array([0,-1,0,178]),np.array([0,0,1,180])])
    def test_rotate360(self,default,axis_angle):
        modified = copy.deepcopy(default)
        for i in range(np.rint(360/axis_angle[3]).astype(int)):
            modified.rotate(Rotation.from_axis_angle(axis_angle,degrees=True))
        assert geom_equal(modified,default)

    @pytest.mark.parametrize('Eulers',[[32.0,68.0,21.0],
                                       [0.0,32.0,240.0]])
    def test_rotate(self,default,update,reference_dir,Eulers):
        modified = copy.deepcopy(default)
        modified.rotate(Rotation.from_Eulers(Eulers,degrees=True))
        tag = f'Eulers={util.srepr(Eulers,"-")}'
        reference = reference_dir/f'rotate_{tag}.geom'
        if update: modified.to_file(reference)
        assert geom_equal(modified,Geom.from_file(reference))

    def test_canvas(self,default):
        grid_add = np.random.randint(0,30,(3))
        modified = copy.deepcopy(default)
        modified.canvas(modified.grid + grid_add)
        e = default.grid
        assert np.all(modified.microstructure[:e[0],:e[1],:e[2]] == default.microstructure)

    @pytest.mark.parametrize('periodic',[True,False])
    def test_tessellation_approaches(self,periodic):
        grid   = np.random.randint(10,20,3)
        size   = np.random.random(3) + 1.0
        N_seeds= np.random.randint(10,30)
        seeds  = np.random.rand(N_seeds,3) * np.broadcast_to(size,(N_seeds,3))
        Voronoi  = Geom.from_Voronoi_tessellation( grid,size,seeds,                 periodic)
        Laguerre = Geom.from_Laguerre_tessellation(grid,size,seeds,np.ones(N_seeds),periodic)
        assert geom_equal(Laguerre,Voronoi)

    def test_Laguerre_weights(self):
        grid   = np.random.randint(10,20,3)
        size   = np.random.random(3) + 1.0
        N_seeds= np.random.randint(10,30)
        seeds  = np.random.rand(N_seeds,3) * np.broadcast_to(size,(N_seeds,3))
        weights= np.full((N_seeds),-np.inf)
        ms     = np.random.randint(1, N_seeds+1)
        weights[ms-1] = np.random.random()
        Laguerre = Geom.from_Laguerre_tessellation(grid,size,seeds,weights,np.random.random()>0.5)
        assert np.all(Laguerre.microstructure == ms)

    @pytest.mark.parametrize('approach',['Laguerre','Voronoi'])
    def test_tessellate_bicrystal(self,approach):
        grid  = np.random.randint(5,10,3)*2
        size  = grid.astype(np.float)
        seeds = np.vstack((size*np.array([0.5,0.25,0.5]),size*np.array([0.5,0.75,0.5])))
        microstructure = np.ones(grid)
        microstructure[:,grid[1]//2:,:] = 2
        if   approach == 'Laguerre':
            geom = Geom.from_Laguerre_tessellation(grid,size,seeds,np.ones(2),np.random.random()>0.5)
        elif approach == 'Voronoi':
            geom = Geom.from_Voronoi_tessellation(grid,size,seeds,            np.random.random()>0.5)
        assert np.all(geom.microstructure == microstructure)
