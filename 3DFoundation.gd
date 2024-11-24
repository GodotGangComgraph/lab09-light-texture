class_name F extends Control

class AffineMatrices:

	static func get_perspective_matrix(c: float) -> DenseMatrix:
		var m = DenseMatrix.identity(4)
		m.set_element(2, 2, 0)
		m.set_element(2, 3, -1.0/c)
		return m
	
	static func get_view_matrix(pos: Vector3, target: Vector3, up: Vector3) -> DenseMatrix:
		var forward = (pos - target).normalized()
		var right = up.cross(forward).normalized()
		var up_corrected = forward.cross(right)

		var view_matrix = DenseMatrix.identity(4)

		view_matrix.set_element(0, 0, right.x)
		view_matrix.set_element(0, 1, right.y)
		view_matrix.set_element(0, 2, right.z)
		view_matrix.set_element(1, 0, up_corrected.x)
		view_matrix.set_element(1, 1, up_corrected.y)
		view_matrix.set_element(1, 2, up_corrected.z)
		view_matrix.set_element(2, 0, forward.x)
		view_matrix.set_element(2, 1, forward.y)
		view_matrix.set_element(2, 2, forward.z)

		var translation_matrix = DenseMatrix.identity(4)
		translation_matrix.set_element(0, 3, -pos.x)
		translation_matrix.set_element(1, 3, -pos.y)
		translation_matrix.set_element(2, 3, -pos.z)

		return view_matrix.multiply_dense(translation_matrix)


	static func get_mvp_matrix(world_center: Vector3, camera_pos: Vector3, camera_target: Vector3, c: float) -> DenseMatrix:
		var up = Vector3(0, 1, 0)
		var translate_from = get_translation_matrix(-world_center.x, -world_center.y, -world_center.z)
		var perspective_matrix = get_perspective_matrix(c).transposed()
		var view_matrix = get_view_matrix(camera_pos, camera_target, up)
		var translate_to = get_translation_matrix(world_center.x, world_center.y, world_center.z)
		#var translate_to = DenseMatrix.identity(4)
		var m1 = translate_from.multiply_dense(view_matrix.transposed())
		var m2 = m1.multiply_dense(perspective_matrix)
		return m2.multiply_dense(translate_to)

	static func get_axonometric_matrix(phi_deg: float, psi_deg: float) -> DenseMatrix:
		var phi = deg_to_rad(phi_deg)
		var psi = deg_to_rad(psi_deg)
		var m = DenseMatrix.zero(4)
		m.set_element(0, 0, cos(psi))
		m.set_element(0, 1, sin(psi) * cos(phi))
		m.set_element(1, 1, cos(phi))
		m.set_element(2, 0, sin(psi))
		m.set_element(2, 1, -sin(phi) * cos(psi))
		m.set_element(3, 3, 1)
		return m


	static func get_translation_matrix(tx: float, ty: float, tz: float) -> DenseMatrix:
		var m = DenseMatrix.identity(4)
		m.set_element(3, 0, tx)
		m.set_element(3, 1, ty)
		m.set_element(3, 2, tz)
		return m

	static func get_rotation_matrix_about_x(ox: float) -> DenseMatrix:
		var m = DenseMatrix.identity(4)

		var rot_deg_x = deg_to_rad(ox)
		var sin_x = sin(rot_deg_x)
		var cos_x = cos(rot_deg_x)

		m.set_element(1, 1, cos_x)
		m.set_element(1, 2, sin_x)
		m.set_element(2, 1, -sin_x)
		m.set_element(2, 2, cos_x)
		return m

	static func get_rotation_x_by_sin_cos(sin_x: float, cos_x: float) -> DenseMatrix:
		var m = DenseMatrix.identity(4)
		m.set_element(1, 1, cos_x)
		m.set_element(1, 2, sin_x)
		m.set_element(2, 1, -sin_x)
		m.set_element(2, 2, cos_x)
		return m

	static func get_rotation_y_by_sin_cos(sin_y: float, cos_y: float) -> DenseMatrix:
		var m = DenseMatrix.identity(4)
		m.set_element(0, 0, cos_y)
		m.set_element(0, 2, -sin_y)
		m.set_element(2, 0, sin_y)
		m.set_element(2, 2, cos_y)
		return m

	static func get_rotation_matrix_about_y(oy: float) -> DenseMatrix:
		var m = DenseMatrix.identity(4)

		var rot_deg_y = deg_to_rad(oy)
		var sin_y = sin(rot_deg_y)
		var cos_y = cos(rot_deg_y)

		m.set_element(0, 0, cos_y)
		m.set_element(0, 2, -sin_y)
		m.set_element(2, 0, sin_y)
		m.set_element(2, 2, cos_y)
		return m

	static func get_rotation_matrix_about_z(oz: float) -> DenseMatrix:
		var m = DenseMatrix.identity(4)

		var rot_deg_z = deg_to_rad(oz)
		var sin_z = sin(rot_deg_z)
		var cos_z = cos(rot_deg_z)

		m.set_element(0, 0, cos_z)
		m.set_element(0, 1, sin_z)
		m.set_element(1, 0, -sin_z)
		m.set_element(1, 1, cos_z)
		return m

	static func get_scale_matrix(mx: float, my: float, mz: float) -> DenseMatrix:
		var m = DenseMatrix.identity(4)

		if mx == 0:
			m.set_element(0, 0, 1)
		else:
			m.set_element(0, 0, mx)

		if my == 0:
			m.set_element(1, 1, 1)
		else:
			m.set_element(1, 1, my)

		if mz == 0:
			m.set_element(2, 2, 1)
		else:
			m.set_element(2, 2, mz)

		return m

	static func get_line_rotate_matrix(l, m, n, sin_phi, cos_phi) -> DenseMatrix:
		var matr = DenseMatrix.identity(4)
		matr.set_element(0, 0, l*l+cos_phi*(1-l*l))
		matr.set_element(0, 1, l*(1-cos_phi)*m+n*sin_phi)
		matr.set_element(0, 2, l*(1-cos_phi)*n-m*sin_phi)
		matr.set_element(1, 0, l*(1-cos_phi)*m-n*sin_phi)
		matr.set_element(1, 1, m*m+cos_phi*(1-m*m))
		matr.set_element(1, 2, m*(1-cos_phi)*n+l*sin_phi)
		matr.set_element(2, 0, l*(1-cos_phi)*n+m*sin_phi)
		matr.set_element(2, 1, m*(1-cos_phi)*n-l*sin_phi)
		matr.set_element(2, 2, n*n+cos_phi*(1-n*n))
		return matr


class Point:
	var x: float
	var y: float
	var z: float
	var w: float

	func _init(_x: float, _y: float, _z: float) -> void:
		x = _x
		y = _y
		z = _z
		w = 1

	static func from_vec3d(_p: Vector3) -> Point:
		var p = Point.new(0,0,0)
		return p

	func duplicate() -> Point:
		var p = Point.new(0, 0, 0)
		p.x = x
		p.y = y
		p.z = z
		p.w = w
		return p

	func apply_matrix(matrix: DenseMatrix):
		var v = get_vector()
		var vnew = v.multiply_dense(matrix)
		x = vnew.get_element(0, 0)
		y = vnew.get_element(0, 1)
		z = vnew.get_element(0, 2)
		w = vnew.get_element(0, 3)

	func translate(tx: float, ty: float, tz: float):
		var matrix = AffineMatrices.get_translation_matrix(tx, ty, tz)
		apply_matrix(matrix)

	func rotate_ox(ox: float):
		var matrix = AffineMatrices.get_rotation_matrix_about_x(ox)
		apply_matrix(matrix)

	func rotate_oy(oy: float):
		var matrix = AffineMatrices.get_rotation_matrix_about_y(oy)
		apply_matrix(matrix)

	func rotate_oz(oz: float):
		var matrix = AffineMatrices.get_rotation_matrix_about_z(oz)
		apply_matrix(matrix)

	func get_vector() -> DenseMatrix:
		return DenseMatrix.from_packed_array([x, y, z, w], 1, 4)

	func get_vec2d():
		return Vector2(x/w, y/w)

	func get_vec3d():
		return Vector3(x/w, y/w, z/w)


class Spatial:
	var points: Array[Point]
	var point_normals: Array[Point]
	var mid_point: Point = Point.new(0, 0, 0)
	var faces #Array[Array[int]]
	var visible_faces
	var normals: Array[Vector3]
	var color: Color
	func _init() -> void:
		points = []
		point_normals = []
		faces = []
		visible_faces = []
		color = Color.DARK_ORANGE
	func add_point(p: Point):
		points.append(p)

	func add_points(arr: Array[Point]):
		points += arr

	func add_face(arr: Array):
		faces.append(arr)

	func add_faces(arr):
		faces += arr

	func add_edge(p1: Point, p2: Point):
		points.append(p1)
		points.append(p2)
		
	func clear():
		points.clear()
		faces.clear()
	
	func get_middle():
		return mid_point.duplicate()

	func apply_matrix(matrix: DenseMatrix):
		for i in range(points.size()):
			points[i].apply_matrix(matrix)
			point_normals[i].apply_matrix(matrix)
		mid_point.apply_matrix(matrix)

	func translate(tx: float, ty: float, tz: float):
		var matrix: DenseMatrix = AffineMatrices.get_translation_matrix(tx, ty, tz)
		apply_matrix(matrix)

	func rotation_about_x(ox: float):
		var matrix: DenseMatrix = AffineMatrices.get_rotation_matrix_about_x(ox)
		apply_matrix(matrix)

	func rotation_about_y(oy: float):
		var matrix: DenseMatrix = AffineMatrices.get_rotation_matrix_about_y(oy)
		apply_matrix(matrix)

	func rotation_about_z(oz: float):
		var matrix: DenseMatrix = AffineMatrices.get_rotation_matrix_about_z(oz)
		apply_matrix(matrix)

	func rotation_about_center(p: Point, ox: float, oy: float, oz: float):
		translate(-p.x, -p.y, -p.z)
		rotation_about_x(float(ox))
		rotation_about_y(float(oy))
		rotation_about_z(float(oz))
		translate(p.x, p.y, p.z)

	func rotation_about_line(p: Point, vec: Vector3, deg: float):
		deg = deg_to_rad(deg)
		vec = vec.normalized()
		
		var n = vec.z
		var m = vec.y
		var l = vec.x
		var d = sqrt(m * m + n * n)
		var matrix = AffineMatrices.get_line_rotate_matrix(l, m, n, sin(deg), cos(deg))
		apply_matrix(matrix)

	func scale_about_center(p: Point, ox: float, oy: float, oz: float):
		translate(-p.x, -p.y, -p.z)
		scale_(ox, oy, oz)
		translate(p.x, p.y, p.z)

	func scale_(mx: float, my: float, mz: float):
		var matrix: DenseMatrix = AffineMatrices.get_scale_matrix(mx, my, mz)
		apply_matrix(matrix)

	func miror(mx: float, my: float, mz: float):
		var matrix = DenseMatrix.identity(4)
		matrix.set_element(0, 0, mx)
		matrix.set_element(1, 1, my)
		matrix.set_element(2, 2, mz)
		apply_matrix(matrix)

	func load_from_obj(file_path: String):
		var file = FileAccess.open(file_path, FileAccess.READ)
		if file == null:
			return
			
		while file.get_position() < file.get_length():
			var line = file.get_line().strip_edges()
			if line.begins_with("v "):
				var parts = line.split(" ")
				if parts.size() >= 4:
					var x = parts[1].to_float()
					var y = -parts[2].to_float()
					var z = -parts[3].to_float()
					add_point(Point.new(x,y,z))
			elif line.begins_with("f "):
				var parts = line.split(" ")
				var face_indices = []
				for i in range(1, parts.size()):
					var vertex_index = parts[i].split("/")[0].to_int() - 1
					face_indices.append(vertex_index)
				add_face(face_indices)
			elif line.begins_with("vn "):
				var parts = line.split(" ")
				if parts.size() >= 4:
					var x = parts[1].to_float()
					var y = -parts[2].to_float()
					var z = -parts[3].to_float()
					point_normals.append(Point.new(x,y,z))
		calculate_normals()
		triangulate_faces()
		scale_about_center(mid_point, 128, 128, 128)
		file.close()

	func save_from_obj(file_path: String):
		var file = FileAccess.open(file_path, FileAccess.WRITE)
		if file == null:
			return
			
		for point in points:
			var line = "v %f %f %f\n" % [point.x, -point.y, -point.z]
			file.store_string(line)
			
		for face in faces:
			var line = "f"
			for vertex_index in face:
				line += " %d" % (vertex_index + 1)
			line += "\n"
			file.store_string(line)
			
		file.close()
		
	func calculate_normals():
		normals = []
		for face in faces:
			var p1 = points[face[0]].duplicate().get_vec3d()
			var p2 = points[face[1]].duplicate().get_vec3d()
			var p3 = points[face[2]].duplicate().get_vec3d()
			var mp = (p1 + p2 + p3) / 3
			var v1 = p2 - p1
			var v2 = p3 - p1
			var n = v2.cross(v1)
			normals.append(n)
			
	
	func remove_back_faces(view_vector: Vector3):
		var v_faces = []
		var visible_normals: Array[Vector3] = []
		
		for i in range(faces.size()):
			var face = faces[i]
			var normal = normals[i]
			var dot_product = normal.dot(view_vector)
			if dot_product > 0:
				v_faces.append(face)
				visible_normals.append(normal)
		visible_faces = v_faces
	
	func triangulate_faces():
		var new_faces = []
		for i in range(faces.size()):
			var face = faces[i]
			for j in range(2, face.size()):
				new_faces.append([face[j], face[j-1], face[0]])
		faces = new_faces


class Axis extends Spatial:
	func _init():
		var l = 500

		## THIS IS POINTS FROM SPATIAL
		points = [
			Point.new(0, 0, 0),
			Point.new(l, 0, 0),
			Point.new(0, l, 0),
			Point.new(0, 0, l),
		]
		
		## THIS IS PLACEHOLDER
		point_normals = [
			Point.new(0, 0, 0),
			Point.new(l, 0, 0),
			Point.new(0, l, 0),
			Point.new(0, 0, l),
		]
		
		faces = [
			[0, 1],
			[0, 2],
			[0, 3]
		]
