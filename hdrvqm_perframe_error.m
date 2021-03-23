function error_frame = hdrvqm_perframe_error(frame_count,path_src_emitted, path_hrc_emitted)
		config_hdrvqm
		Images_List_HDR_src = dir([path_src_emitted '*.hdr']);
		Images_List_EXR_src = dir([path_src_emitted '*.exr']);
		Images_List_HDR_hrc = dir([path_hrc_emitted '*.hdr']);
		Images_List_EXR_hrc = dir([path_hrc_emitted '*.exr']);
		Images_List_src = [Images_List_HDR_src;Images_List_EXR_src];
		Images_List_hrc = [Images_List_HDR_hrc;Images_List_EXR_hrc];
		for index = 1:length(Images_List_src)
			Image_Name_src{index} = Images_List_src(index).name;
		end
		for index = 1:length(Images_List_hrc)
			Image_Name_hrc{index} = Images_List_hrc(index).name;
		end
		flag_format = find([length(Images_List_HDR_src) length(Images_List_EXR_src)]);
		if(flag_format ==1)
			format = '.hdr';
		else
			format = '.exr';
		end
		
		if(strcmp(Image_Name_src{frame_count}(end-3:end),'.hdr'))
					src_value = (hdrimread([path_src_emitted Image_Name_src{frame_count}]));
		else
					src_value = exrread([path_src_emitted Image_Name_src{frame_count}]);
		end
		src_value = clip_luminance(src_value,format,cfg_hdrvqm);
		org_frame(frame_count).name = 'cdata';
		I_org = (double(lum(src_value)));
		org_frame(frame_count).cdata = RemoveSpecials(I_org);
		clear original_value I_org
		
		
				if(strcmp(Image_Name_hrc{frame_count}(end-3:end),'.hdr'))
						hrc_value = (hdrimread([path_hrc_emitted Image_Name_hrc{frame_count}]));
				else
				hrc_value = exrread([path_hrc_emitted Image_Name_hrc{frame_count}]);
				end
		hrc_value = clip_luminance(hrc_value,format,cfg_hdrvqm);
		dis_frame(frame_count).name = 'cdata';
		I_dis = (double(lum(hrc_value)));
		dis_frame(frame_count).cdata = RemoveSpecials(I_dis);
		clear distorted_value I_dis
			
		 
		error_frame = subband_errors(((((double(pu_encode_new((org_frame(frame_count).cdata))))))),(((((double(pu_encode_new((dis_frame(frame_count).cdata)))))))),cfg_hdrvqm.n_scale,cfg_hdrvqm.n_orient);
end
