## Low-level bindings to Dav1d

{.push cdecl, dynlib: "libdav1d.so(|.|.|)".}

{.push importc.}
var
  DAV1D_MAX_CDEF_STRENGTHS*: cint
  DAV1D_MAX_OPERATING_POINTS*: cint
  DAV1D_MAX_TILE_COLS*: cint
  DAV1D_MAX_TILE_ROWS*: cint
  DAV1D_MAX_SEGMENTS*: cint
  DAV1D_NUM_REF_FRAMES*: cint
  DAV1D_PRIMARY_REF_NONE*: cint
  DAV1D_REFS_PER_FRAME*: cint
  DAV1D_TOTAL_REFS_PER_FRAME*: cint
{.pop.}

type
  Dav1dLogger* = object
    cookie*: pointer
    callback*: proc(cookie: pointer, format: cstring, ap: pointer) {.cdecl.}

  Dav1dPicAllocator* = object
  Dav1dContext* = object
  Dav1dRef* = object

  Dav1dPixelLayout* = enum
    DAV1D_PIXEL_LAYOUT_I400 # Monochrome
    DAV1D_PIXEL_LAYOUT_I420 # 4:2:0 planar
    DAV1D_PIXEL_LAYOUT_I422 # 4:2:2 planar
    DAV1D_PIXEL_LAYOUT_I444 # 4:4:4 planar

  Dav1dColorPrimaries* = enum
    DAV1D_COLOR_PRI_BT709 = 1
    DAV1D_COLOR_PRI_UNKNOWN = 2
    DAV1D_COLOR_PRI_BT470M = 4
    DAV1D_COLOR_PRI_BT470BG = 5
    DAV1D_COLOR_PRI_BT601 = 6
    DAV1D_COLOR_PRI_SMPTE240 = 7
    DAV1D_COLOR_PRI_FILM = 8
    DAV1D_COLOR_PRI_BT2020 = 9
    DAV1D_COLOR_PRI_XYZ = 10
    DAV1D_COLOR_PRI_SMPTE431 = 11
    DAV1D_COLOR_PRI_SMPTE432 = 12
    DAV1D_COLOR_PRI_EBU3213 = 22
    DAV1D_COLOR_PRI_RESERVED = 255

  Dav1dTransferCharacteristics* = enum
    DAV1D_TRC_BT709 = 1
    DAV1D_TRC_UNKNOWN = 2
    DAV1D_TRC_BT470M = 4
    DAV1D_TRC_BT470BG = 5
    DAV1D_TRC_BT601 = 6
    DAV1D_TRC_SMPTE240 = 7
    DAV1D_TRC_LINEAR = 8
    DAV1D_TRC_LOG100 = 9        # < logarithmic (100:1 range)
    DAV1D_TRC_LOG100_SQRT10 = 10 # < lograithmic (100*sqrt(10):1 range)
    DAV1D_TRC_IEC61966 = 11
    DAV1D_TRC_BT1361 = 12
    DAV1D_TRC_SRGB = 13
    DAV1D_TRC_BT2020_10BIT = 14
    DAV1D_TRC_BT2020_12BIT = 15
    DAV1D_TRC_SMPTE2084 = 16     # < PQ
    DAV1D_TRC_SMPTE428 = 17
    DAV1D_TRC_HLG = 18           # < hybrid log/gamma (BT.2100 / ARIB STD-B67)
    DAV1D_TRC_RESERVED = 255

  Dav1dMatrixCoefficients* = enum
    DAV1D_MC_IDENTITY = 0,
    DAV1D_MC_BT709 = 1,
    DAV1D_MC_UNKNOWN = 2,
    DAV1D_MC_FCC = 4,
    DAV1D_MC_BT470BG = 5,
    DAV1D_MC_BT601 = 6,
    DAV1D_MC_SMPTE240 = 7,
    DAV1D_MC_SMPTE_YCGCO = 8,
    DAV1D_MC_BT2020_NCL = 9,
    DAV1D_MC_BT2020_CL = 10,
    DAV1D_MC_SMPTE2085 = 11,
    DAV1D_MC_CHROMAT_NCL = 12, # < Chromaticity-derived
    DAV1D_MC_CHROMAT_CL = 13,
    DAV1D_MC_ICTCP = 14,
    DAV1D_MC_RESERVED = 255

  Dav1dData* = object
    data*: cstring
    sz*: csize_t
    `ref`*: ptr Dav1dRef
    m*: Dav1dDataProps

  Dav1dDataProps* = object
    timestamp*: int64
    duration*: int64
    offset*: int64
    size*: csize_t
    user_data*: Dav1dUserData

  Dav1dUserData* = object
    data*: cstring
    `ref`*: ptr Dav1dRef

  Dav1dChromaSamplePosition* = enum
    DAV1D_CHR_UNKNOWN = 0
    DAV1D_CHR_VERTICAL = 1
    DAV1D_CHR_COLOCATED = 2

  Dav1dInloopFilterType* = enum
    DAV1D_INLOOPFILTER_NONE = 0
    DAV1D_INLOOPFILTER_DEBLOCK = 1 shl 0
    DAV1D_INLOOPFILTER_CDEF = 1 shl 1
    DAV1D_INLOOPFILTER_RESTORATION = 1 shl 2
    DAV1D_INLOOPFILTER_ALL = DAV1D_INLOOPFILTER_DEBLOCK.int or DAV1D_INLOOPFILTER_CDEF.int or DAV1D_INLOOPFILTER_RESTORATION.int

  Dav1dSequenceHeaderOperatingPoint* = object
    major_level*, minor_level*, initial_display_delay*: char
    idc*: cshort
    tier*: cchar
    decoder_model_param_present*, display_model_param_present*: char

  Dav1dFilmGrainData* = object
    seed*: uint
    num_y_points*: cint
    y_points*: array[14, array[2, uint8]]
    chroma_scaling_from_luma*: cint
    num_uv_points*: array[2, cint]
    # todo

  Dav1dFrameHeaderFilmGrain* = object
    data*: Dav1dFilmGrainData
    present*, update*: uint8

  Dav1dFrameType* = enum
    DAV1D_FRAME_TYPE_KEY = 0,    # < Key Intra frame
    DAV1D_FRAME_TYPE_INTER = 1,  # < Inter frame
    DAV1D_FRAME_TYPE_INTRA = 2,  # < Non key Intra frame
    DAV1D_FRAME_TYPE_SWITCH = 3, # < Switch Inter frame

  Dav1dFrameHeaderOperatingPoint* = object
    buffer_removal_time*: uint32

  Dav1dFrameHeaderSuperRes* = object
    width_scale_denominator*, enabled*: uint8

  Dav1dFilterMode* = enum
    DAV1D_FILTER_8TAP_REGULAR
    DAV1D_FILTER_8TAP_SMOOTH
    DAV1D_FILTER_8TAP_SHARP
    DAV1D_N_SWITCHABLE_FILTERS
    DAV1D_FILTER_BILINEAR = DAV1D_N_SWITCHABLE_FILTERS
    DAV1D_N_FILTERS
    DAV1D_FILTER_SWITCHABLE = DAV1D_N_FILTERS

  Dav1dFrameHeader* = object
    film_grain*: Dav1dFrameHeaderFilmGrain
    frame_type*: Dav1dFrameType
    width*: array[2, cint]
    height*: cint
    frame_offset*, temporal_id*, spatial_id*, show_existing_frame*, existing_frame_idx*: uint8
    frame_id*, frame_presentation_delay*: uint32
    show_frame*, showable_frame*, error_resillient_mode*, disable_cdf_update*, allow_screen_content_tools*, force_integer_mv*, frame_size_override*, primary_ref_frame*, buffer_removal_time_present*: uint8
    operating_points*: array[DAV1D_MAX_OPERATING_POINTS, Dav1dFrameHeaderOperatingPoint]
    refresh_frame_flags*: uint8
    render_width*, render_height*: cint
    super_res*: Dav1dFrameHeaderSuperRes
    have_render_size*, allow_intrabc*, frame_ref_short_signaling*: uint8
    refidx*: array[DAV1D_REFS_PER_FRAME, int8]
    hp*: uint8
    subpel_filter_mode*: Dav1dFilterMode

  Dav1dPicture* = object
    seq_hdr*: Dav1dSequenceHeader
    frame_hdr*: Dav1dFrameHeader

    data*: array[3, pointer]
    stride*: array[2, int32]

    p*: Dav1dPictureParameters
    m*: Dav1dDataProps

    content_light*: Dav1dContentLightLevel
    mastering_display*: Dav1dMasteringDisplay
    itut_t35*: Dav1dITUTT35

    n_itut_t35*: csize_t
    reserved*: array[4, ptr uint]

    frame_hdr_ref*, seq_hdr_ref*, content_light_ref*, mastering_display_ref*, itut_t35_ref*: ptr Dav1dRef
    reserved_ref*: array[4, ptr uint]
    `ref`*: ptr Dav1dRef

    allocator_data*: pointer
  
  Dav1dSequenceHeader* = object
    profile*: char
    max_width*, max_height*: cint
    layout*: Dav1dPixelLayout
    pri*: Dav1dColorPrimaries
    trc*: Dav1dTransferCharacteristics
    mtrx*: Dav1dMatrixCoefficients
    chr*: Dav1dChromaSamplePosition

    hbd*: char
    color_range*: char
    num_operating_points*: char
    operating_points*: Dav1dSequenceHeaderOperatingPoint
    still_picture*, reduced_still_picture_header*, timing_info_present*: cchar
    num_units_in_tick*, time_scale*: culong
    equal_picture_interval*: cchar
    num_ticks_per_picture*: culong
    decoder_model_info_present*, encoder_decoder_buffer_delay_length*: char
    num_units_in_decoding_tick*: culong
    buffer_removal_delay_length*, frame_presentation_delay_length*, display_model_info_present*, width_n_bits*, height_n_bits*: char
    frame_id_numbers_present*, delta_frame_id_n_bits*, frame_id_n_bits*, sb128*, filter_intra*, intra_edge_filter*, inter_intra*, masked_compound*: char
    warped_motion*, dual_filter*, order_hint*, jnt_comp*, ref_frame_mvs*: char

  Dav1dSettings* = object
    n_threads*: cint
    max_frame_delay*, apply_grain*, operating_point*, all_layers*: cint
    frame_size_limit*: cuint
    allocator*: Dav1dPicAllocator
    logger*: Dav1dLogger
    strict_std_compliance*: cint
    output_invisible_frames*: cint
    inloop_filters*: Dav1dInloopFilterType

{.pop.}

{.push cdecl, dynlib: "libdav1d.so(|.|.|)", importc.}

proc dav1d_version*: cstring
proc dav1d_version_api*: cuint
proc dav1d_default_settings*(s: ptr Dav1dSettings)
proc dav1d_open*(c_out: ptr ptr Dav1dContext, s: Dav1dSettings): cint
proc dav1d_close*(c_out: ptr ptr Dav1dContext)
proc dav1d_parse_sequence_header*(`out`: Dav1dSequenceHeader, buf: cstring, sz: csize_t): cint
proc dav1d_send_data*(c: ptr Dav1dContext, `in`: Dav1dData)
proc dav1d_get_picture*(c: ptr Dav1dContext, `out`: Dav1dPicture)

{.pop.}
