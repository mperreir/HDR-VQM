function HDRVQM = hdr_vqm(path_src_native,path_hrc_native,path_src_emitted,path_hrc_emitted)
%set the default parameters, run the config file
config_hdrvqm
switch cfg_hdrvqm.do_adapt
		case ('none')
		fprintf('\nNo display processing requested...\n') 
		pause(1)
		fprintf('\nQuality will be computed assuming that the input data is scaled according to display...\n\n')
		case('linear')
		fprintf('\nProcessing source and distorted videos using linear scaling...\n') 
		pause(1)
		%fprintf('\nScaling factor is determined from the entire sequence (not individual frames).\n') 
		%pause(1)
		fprintf('\nQuality will be computed on the processed sequences.\n\n')
    otherwise
        error('Invalid selection of display processing')
end		
adapt_display_hdrvqm(path_src_native,path_src_emitted,cfg_hdrvqm);
adapt_display_hdrvqm(path_hrc_native,path_hrc_emitted,cfg_hdrvqm);


		Images_List_HDR_src = dir([path_src_emitted '*.hdr']);
		Images_List_EXR_src = dir([path_src_emitted '*.exr']);
		Images_List_HDR_hrc = dir([path_hrc_emitted '*.hdr']);
		Images_List_EXR_hrc = dir([path_hrc_emitted '*.exr']);
		Images_List_src = [Images_List_HDR_src;Images_List_EXR_src];
		Images_List_hrc = [Images_List_HDR_hrc;Images_List_EXR_hrc];

		flag_number_image = numel(Images_List_src);
		switch cfg_hdrvqm.data
			case('image')
				if(flag_number_image~=1)
						error('More than one image detected. Specify video in this case')
					end
			case('video')
				if(flag_number_image==1)
						error('One image/frame detected. Specify image option in this case')
					end
		end
		
	

if cfg_hdrvqm.do_parallel_loop
%(optional) use a parallel loop for faster processing
			matlabpool open 4
            fprintf('\nComputing quality...\n')			
			parfor frame_count = 1:numel(Images_List_src)
			     
			     error_video_hdrvqm(:,:,frame_count) = hdrvqm_perframe_error(frame_count,path_src_emitted, path_hrc_emitted);
				 
			end
			switch cfg_hdrvqm.data
				case('image')
					HDRVQM = st_pool(st_pool(error_video_hdrvqm,0.5),0.5);
					fprintf('\nHDR-VQM for image is: %f\n',HDRVQM)
					clear error_video_hdrvqm
					matlabpool close force local
				case('video')
					HDRVQM = hdrvqm_error_pooling(error_video_hdrvqm,cfg_hdrvqm);
					fprintf('\nHDR-VQM for video is: %f\n',HDRVQM)
					clear error_video_hdrvqm
					matlabpool close force local
			end	
			
			
else
            fprintf('\nComputing quality...\n')			
			for frame_count = 1:numel(Images_List_src)
			     
			     error_video_hdrvqm(:,:,frame_count) = hdrvqm_perframe_error(frame_count,path_src_emitted, path_hrc_emitted);
				 
			end
			switch cfg_hdrvqm.data
				case('image')
					HDRVQM = st_pool(st_pool(error_video_hdrvqm,0.5),0.5);
					fprintf('\nHDR-VQM for image is: %f\n',HDRVQM)
					clear error_video_hdrvqm
					matlabpool close force local
				case('video')
					HDRVQM = hdrvqm_error_pooling(error_video_hdrvqm,cfg_hdrvqm);
					fprintf('\nHDR-VQM for video is: %f\n',HDRVQM)
					clear error_video_hdrvqm
			end
end
end
			
			
			