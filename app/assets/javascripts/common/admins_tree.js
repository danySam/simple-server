const AccessTree = function () {
	const self = this;

	const parents = {
		facility: "facilityGroup",
		facilityGroup: "organization",
	};

	const children = _.invert(parents);

	getParentKeyId = function (accessType) {
		return parents[accessType] + "Id" || "parentId";
	};

	addAccessItemMetaData = function (result, value, _key) {
		const accessType = value.dataset.accessType;
		const parentKey = getParentKeyId(accessType);
		const parentId = value.dataset[parentKey];
		const checkbox = value.querySelector(ACCESS_LIST_INPUT_SELECTOR)
		const accessItem = {
			element: value,
			checkbox,
			[parentKey]: parentId,
			name: value.dataset.name,
			accessType,
			parent: getElementParent(accessType, parentId),
			children: getElementChildren(accessType, value.dataset.id),
			deepChildren: getElementChildrenDeep(accessType, value.dataset.id)
		}

		// There are a lot of looks between checkbox and the access item
		checkbox.accessItem = accessItem
		return (result[value.dataset.id] = accessItem);
	};

	getElementParent = function (accessType, parentId) {
		return function () {
			const tree = self.accessTree;
			const parentKey = parents[accessType];
			if (!parentKey || !tree[parentKey]) return;

			return tree[parentKey][parentId];
		};
	};

	getElementChildrenDeep = function (accessType, itemId) {
		return function () {
			const childElements = getElementChildren(accessType, itemId)()
			const childAccessType = children[accessType]
			if (!childAccessType) return childElements
			const grandChildren = childElements.flatMap(child => getElementChildrenDeep(childAccessType, child.element.dataset.id)())
			return [...childElements, ...grandChildren]
		}
	};

	getElementChildren = function (accessType, itemId) {
		return function () {
			const tree = self.accessTree;
			const childKey = children[accessType];
			const parentIdKey = getParentKeyId(childKey);
			if (!childKey) return [];

			return Object.values(tree[childKey]).filter(
				(item) => item[parentIdKey] === itemId
			);
		};
	};

	getParentAccessItem = function (element) {
		const accessItem = element.closest("div.access-item")
		return this.accessTree[accessItem.dataset.accessType][accessItem.dataset.id]
	}

	buildAccessTree = function () {
		const accessItems = Array.from(document.querySelectorAll(".access-item"));
		const data = _.groupBy(accessItems, (item) => item.dataset.accessType);

		const tree = _.transform(
			data,
			(result, value, key) =>
				(result[key] = _.transform(value, addAccessItemMetaData, {}))
		);
		return {
			accessItems,
			tree,
		};
	};

	const { accessItems, tree } = buildAccessTree()
	this.accessTree = tree
	this.nodes = accessItems
	this.getParentAccessItem = getParentAccessItem
};
