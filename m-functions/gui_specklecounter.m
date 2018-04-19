function gui_specklecounter(varargin)
% GUI_SPECKLECOUNTER  Brief description.
%                     User interface to count specles given an input image file.

% Leave a blank line following the help.

% Initialization tasks
%  Create and then hide the GUI as it is being constructed.
fig_gui = figure('Visible','on',...
    'Name','Speckles counter',...
    'NumberTitle','off',...
    'Position',[100 100 1100 500]);

% Construct the components
% - panels
h_panel_results=uipanel('Title','Results','Parent',fig_gui,...
    'FontSize',11,'Backgroundcolor',get(fig_gui,'color'),...
    'Position',[.15,.03,.47,.3]);
h_panel_hist=uipanel('Title','Histogram','Parent',fig_gui,...
    'FontSize',11,'Backgroundcolor',get(fig_gui,'color'),...
    'Position',[.65,.03,.33,.95]);
h_panel_controls=uipanel('Title','Control','Parent',fig_gui,...
    'FontSize',11,'Backgroundcolor',get(fig_gui,'color'),...
    'Position',[.02,.03,.12,.95]);
h_panel_image=uipanel('Title','Viewer','Parent',fig_gui,...
    'FontSize',11,'Backgroundcolor',get(fig_gui,'color'),...
    'Position',[.15,.37,.47,.61]);

% - components inside histogram panel
ax_hist=zeros(4,1);
ax_hist(1)=axes('Parent',h_panel_hist,...
    'units','normalized','Position',[.1 .8 .8 .18],...
    'box','on','Visible','off',...
    'fontsize',8);
ax_hist(2)=axes('Parent',h_panel_hist,...
    'units','normalized','Position',[.1 .55 .8 .18],...
    'box','on','Visible','off',...
    'fontsize',8);
ax_hist(3)=axes('Parent',h_panel_hist,...
    'units','normalized','Position',[.1 .31 .8 .18],...
    'box','on','Visible','off',...
    'fontsize',8);
ax_hist(4)=axes('Parent',h_panel_hist,...
    'units','normalized','Position',[.1 .08 .8 .18],...
    'box','on','Visible','off',...
    'fontsize',8);

% - components inside image panel
ax_view=axes('Parent',h_panel_image,...
    'units','normalized','Position',[.0 .05 .5 .8],...
    'box','on','xtick',[],'ytick',[]);
ax_thres=axes('Parent',h_panel_image,...
    'units','normalized','Position',[.5 .05 .5 .8],...
    'box','on','xtick',[],'ytick',[]);
h_text_nodata=uicontrol('Style','text',...
    'Parent',h_panel_image,...
    'String','No data',...
    'Units','normalized','Position',[.1 .3 .8 .3],...
    'fontsize',30,'horizontalalignment','center',...
    'Visible','off',...
    'backgroundcolor',get(fig_gui,'color'));
h_text_frame=uicontrol('Style','text',...
    'Parent',h_panel_image,...
    'String','Frame 1',...
    'Units','normalized','Position',[.0 .9 1 .08],...
    'fontsize',10,'horizontalalignment','center',...
    'backgroundcolor',get(fig_gui,'color'));

% - components inside control panel
h_button_previousFrame = uicontrol('Style','Pushbutton',...
    'Parent',h_panel_controls,...
    'String','Previous','Fontsize',10,...
    'Units','normalized','Position',[.1 .9 .82 .08],...
    'Callback',{@callback_showPreviousFrame});
h_button_nextFrame = uicontrol('Style','Pushbutton',...
    'Parent',h_panel_controls,...
    'String','Next','Fontsize',10,...
    'Units','normalized','Position',[.1 .8 .82 .08],...
    'Callback',{@callback_showNextFrame});
h_button_saveFile = uicontrol('Style','Pushbutton',...
    'Parent',h_panel_controls,...
    'String','Save to file','Fontsize',10,...
    'Units','normalized','Position',[.1 .13 .82 .08],...
    'Callback',{@callback_showNextFrame});
h_button_exit = uicontrol('Style','Pushbutton',...
    'Parent',h_panel_controls,...
    'String','Exit','Fontsize',10,...
    'Units','normalized','Position',[.1 .03 .82 .08],...
    'Callback',{@callback_quit});
h_text_slider=uicontrol('Style','text',...
    'Parent',h_panel_controls,...
    'String','Threshold','Fontsize',10,...
    'Units','normalized','Position',[.1 .65 .82 .05],...
    'Horizontalalignment','center',...
    'Backgroundcolor',get(fig_gui,'color'));
h_text_threshold=uicontrol('Style','text',...
    'Parent',h_panel_controls,...
    'String','0.50','Fontsize',10,...
    'Units','normalized','Position',[.1 .6 .82 .05],...
    'Horizontalalignment','center',...
    'Backgroundcolor',get(fig_gui,'color'));
h_slider_thres = uicontrol('Style','slider',...
    'Parent',h_panel_controls,...
    'Min',0,'Max',1,'Value',0.5,...
    'Units','normalized','Position',[.05 .55 .9 .05],...
    'String','Threshold',...
    'Callback',{@callback_changeThreshold,h_text_threshold});
h_text_sliderFrame=uicontrol('Style','text',...
    'Parent',h_panel_controls,...
    'String','Select frame','Fontsize',10,...
    'Units','normalized','Position',[.1 .45 .82 .05],...
    'Horizontalalignment','center',...
    'Backgroundcolor',get(fig_gui,'color'));
h_slider_frame = uicontrol('Style','slider',...
    'Parent',h_panel_controls,...
    'Min',0,'Max',1,'Value',1,...
    'Units','normalized','Position',[.05 .4 .9 .05],...
    'String','Threshold',...
    'Callback',{@callback_changeFrame});

% - components inside results panel
% h_table_tabRes -- Created after


% Initialization tasks
if(isempty(varargin))
    set(ax_view,'Visible','off');
    set(ax_thres,'Visible','off');
    set(h_text_frame,'Visible','off');
    set(h_text_nodata,'Visible','on');
    data=[];
else
    data=varargin{1};
    if(size(varargin,2)>1)
        dataName=varargin{2};
        set(fig_gui,'Name',['Speckles counter: ',dataName]);
    end
end

if(~isempty(data))
    frameid=1;
    framesN=size(data,3);
    thres_val=0.5;
    tab_specklesInfo=[];
    hist_specklesInfo=[];
    set(h_slider_frame,'Min',0,'Max',framesN);
    for ii=1:numel(ax_hist)
        set(ax_hist(ii),'Visible','on');
    end
    updateViewer(frameid,1);
end

% Callbacks for gui
    function callback_showPreviousFrame(~,~)
        if(isempty(data))
            return;
        end
        frameid=max(1,frameid-1);
        updateViewer(frameid,1);
    end

    function callback_showNextFrame(~,~)
        if(isempty(data))
            return;
        end
        frameid=min(framesN,frameid+1);
        updateViewer(frameid,1);
    end

    function callback_quit(~,~)
        close all;
    end

    function callback_changeThreshold(src,~,hleg)
        val=get(src,'Value');
        set(hleg,'String',num2str(val,'%0.2f'));
        if(isempty(data))
            return;
        end
        thres_val=val;
        updateViewer(frameid);
    end

    function callback_changeFrame(src,~)
        if(isempty(data))
            return;
        end
        val=get(src,'Value');
        val=round(val);
        val=max(1,min(val,framesN));
        frameid=val;
        updateViewer(frameid,1);
    end


% Utility functions for gui
    function updateViewer(id,varargin)
        % Update viewer
        % If varargin != [] ---> new frame selected :. update speckles
        % information for selected thresholds
        
        % Get image
        I=data(:,:,id);
        
        % Normalize image
        I=double(I);
        I=I-min(min(I));
        I=I/max(max(I));
        
        % Apply threshold
        I_thres=false(size(I));
        I_thres(I>thres_val)=true;
        
        % Show original image
        axes(ax_view);
        imshow(I);
        
        % Show thresholded image
        axes(ax_thres);
        imshow(I_thres);
        
        % Update frame information
        set(h_text_frame,'String',['Frame ',num2str(frameid),'/',num2str(framesN)]);
        
        % Update results section
        if(isempty(varargin))
            updateResults(I,thres_val); % Frame did not change
        else
            updateResults(I,thres_val,1); % Frame changed
        end
    end

    function updateResults(I,th,varargin)
        % Updates speckles info in the table
        % - I: original image in view
        % - th: user defined threshold
        
        % Create table data
        if(isempty(tab_specklesInfo))
            tab_specklesInfo=zeros(4,3);
            hist_specklesInfo=cell(4,1);
        end
        
        % Apply user defined threshold 'th' on the original image 'I'
        I_thres=false(size(I));
        I_thres(I>th)=true;
        [n,px,pxs]=specklesInfo(I_thres);
        tab_specklesInfo(1,:)=[th, n, px];
        hist_specklesInfo{1}=pxs;
        
        if(~isempty(varargin)) % New frame :. get results for .2, .4, .6
            % Apply threshold = 0.20 on the original image 'I'
            I_thres=false(size(I));
            I_thres(I>.2)=true;
            [n,px,pxs]=specklesInfo(I_thres);
            tab_specklesInfo(2,:)=[.2, n, px];
            hist_specklesInfo{2}=pxs;
            
            % Apply threshold = 0.40 on the original image 'I'
            I_thres=false(size(I));
            I_thres(I>.4)=true;
            [n,px,pxs]=specklesInfo(I_thres);
            tab_specklesInfo(3,:)=[.4, n, px];
            hist_specklesInfo{3}=pxs;
            
            % Apply threshold = 0.60 on the original image 'I'
            I_thres=false(size(I));
            I_thres(I>.6)=true;
            [n,px,pxs]=specklesInfo(I_thres);
            tab_specklesInfo(4,:)=[.6, n, px];
            hist_specklesInfo{4}=pxs;
        end
        
        % Update table
        % Check if the table exists. If not, create it.
        if(~exist('h_table_tabRes','var'))
            h_table_tabRes=uitable('Parent',h_panel_results,...
                'ColumnName',{'Threshold','Ammount','Avg. size'},'RowName',[],...
                'Units','normalized','Position',[.0,.0,1,1],...
                'Fontsize',10,'Enable','off',...
                'Data',tab_specklesInfo);
        else
            set(h_table_tabRes,'Data',tab_specklesInfo);
        end
        
        % Update Histogram plot
%         histRange=(0:.1:.9)+0.05;
        histRange=10;
        for i=1:numel(ax_hist)
            % The user selected threshold is guaranteed to be updated.
            [bincount,centers]=hist(hist_specklesInfo{i},histRange);
            bincount=bincount/numel(hist_specklesInfo{i});
            h_bar=bar(ax_hist(i),centers,bincount,'hist');
            set(h_bar,'facecolor','c','edgecolor','b');
            hold(ax_hist(i),'on');
            plot(ax_hist(i),[tab_specklesInfo(i,3) tab_specklesInfo(i,3)],[0 1],'-r')
            hold(ax_hist(i),'off');
            
            if(isempty(varargin)) % The frame is not new :. do not update for .2, .4 and .6
               break;
            end
        end
    end

    function [n,px_avg,px_ind]=specklesInfo(bin)
        % Gets speckles info in input binary image "bin":
        % - n: ammount of speckles
        % - px: average size of speckles [px]
        
        % Find connected components in "bin"
        cc=bwconncomp(bin);
        
        % Ammount of speckles
        n=cc.NumObjects;
        
        % Average Size
        px_avg=nnz(bin)/n;
        
        % Speckles size
        px_ind=cellfun(@numel,cc.PixelIdxList);
        
    end

end
