# HDR-VQM version 2 

(released July. 2015)



### General  instructions

The software for HDR-VQM has been developed to objectively measure HDR video quality, and requires src (reference) and hrc (distorted).

For meaningful quality prediction, it requires **display-processed sequences** i.e. HDR video data that has been approximately scaled according to the HDR display. Such display-processing can be done in different ways, and the current version of HDR-VQM software provides implementation for one simple two approach (more details are available in the following article).

### Configuration

Before running HDR-VQM you should carefull read the configuration file `config_hdrvqm.m` and adapt it to your case. In particular:

- `cfg_hdrvqm.data` should be set to `image` or `video` (default) depending on the type of content you want to process.

- `cfg_hdrvqm.do_adapt` 
  - should be set to `none` if you content is already display processed. That is to say it it contains luminance values that correspond to what was really displayed to the user.
  - If your content does not containes display processed value you can use `libnear`. It will linealy scale the luminance values of all frames so that the maximum over is `cfg_hdrvqm.max_display`.
- `cfg_hdrvqm.rows_display` , `cfg_hdrvqm.columns_display`, `cfg_hdrvqm.area_display`, `cfg_hdrvqm.max_display` and `cfg_hdrvqm.min_display` shoudl be set according to the caracteristics of the display used. The default value included in the config file are only valid for the SIM2 HDR display taht we used for our experiments.
- `cfg_hdrvqm.viewing_distance` should be set according to **your** viewing conditions.
- `cfg_hdrvqm.frame_rate` should be set to the framerate of your videos. It is needed in order to know how many frames are viewed during `cfg_hdrvqm.fixation_time`. 

Once the configuration done, you can call HDR-VQM with the following parameters : 

```matlab
hdr_vqm(path_src_native,path_hrc_native,path_src_emitted,path_hrc_emitted)
```

The value returned will be the estimated quality value.

### Reference paper

> M. Narwaria, M. Perreira Da Silva, and P. Le Callet, "HDR-VQM: An objective quality measure for high dynamic range video," Signal Processing: Image Communication, vol. 35, no. 0, pp. 46-60, 2015.

If you find this software (or part of it) useful for your work, we request you to cite the above article. 



### Disclaimer

*******************************************************************************

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHORS DISCLAIM ALL WARRANTIES

WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF

MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR

ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES

WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN

ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF

OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

*******************************************************************************



 